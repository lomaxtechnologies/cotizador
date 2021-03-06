class Quotation < ApplicationRecord
  acts_as_paranoid
  belongs_to :client
  belongs_to :user
  has_many :quotation_products
  has_many :quotation_services
  has_many :attachments
  has_many :quotations_notes
  has_many :comments, as: :commentable
  accepts_nested_attributes_for :quotation_products, allow_destroy: true
  accepts_nested_attributes_for :quotation_services, allow_destroy: true
  has_many_attached :files

  # All the possible quotation types
  enum quotation_type: %i[t_comparative t_siemon_only t_supranet_only t_simple]
  validates :quotation_type, presence: true, inclusion: { in: :quotation_type }

  # All possible states
  enum state: %i[created active accepted expired]
  validates :state, presence: true, inclusion: { in: :state }

  paginates_per 10

  scope :type, ->(params) { select(:quotation_type).where(id: params[:id]) }
  
  def self.header_fields
    Quotation.joins(:client).select(
      'quotations.id',
      'quotations.quotation_date',
      'quotations.quotation_type',
      'quotations.state',
      'clients.name'
    )
  end

  def destroy
    if created? || expired?
      super
    else
      errors.add(:state, :destroy_impossible)
      false
    end
  end

  def activate
    if created?
      active!
    else
      errors.add(:state, :activation_impossible)
      false
    end
  end

  def approve
    if active?
      accepted!
    else
      errors.add(:state, :approve_impossible)
      false
    end
  end

  def expire
    if active?
      expired!
    else
      errors.add(:state, :expiration_impossible)
      false
    end
  end

  # Returns a hash with client information, and detailed products and
  # services information
  def detailed_info
    products = format_products
    products = group_products(products) if t_comparative?
    data = attributes
    .merge(client: client)
    .merge(products)
    .merge(format_services)
    data
  end

  def conditions_only
    attributes.slice("warranty", "payment_condition")
  end

  def header_only
    Quotation.joins(:client).select(
      "quotations.client_id",
      "quotations.quotation_date",
      "quotations.quotation_type",
      "clients.nit as client_nit",
      "clients.name as client_name"
    ).where(
      id: id
    ).first
  end

  def services_only
    format_services[:quotation_services]
  end

  def products_only
    if t_comparative?
      products_only_comparative_format
    else
      products_only_single_brand_format
    end
  end

  # Returns an array containing the ids of the quotation_services
  def services_ids
    quotation_services.map do |element|
      element[:id]
    end
  end

  # Returns an array containing the ids of the quotation_products
  def products_ids
    quotation_products.map do |element|
      element[:id]
    end
  end

  # Clones a quotation and updates prices and services to their current value
  def clone_and_update
    new_quotation = dup
    new_quotation.quotation_date = Date.today.to_s
    quotation_services.each do |quotation_service|
      new_quotation_service = quotation_service.dup
      # Retrieving the service associated with the quotation to be duplicated
      old_service = Service.with_deleted.find_by(id: new_quotation_service.service_id)
      # Retrieving the most recent service with that name and description
      new_service = Service.find_by(name: old_service.name, description: old_service.description)
      if(new_service)
        new_quotation_service.service = new_service
        new_quotation.quotation_services << new_quotation_service
      else
        errors.add(:base, :service_does_not_exist)
        break
      end
    end
    quotation_products.each do |quotation_product|
      new_quotation_product = quotation_product.dup
      new_quotation.quotation_products << new_quotation_product
    end
    new_quotation
  end

  def complex_products
    products = format_products.deep_stringify_keys["quotation_products"]
    brands = ['siemon', 'supranet']

    products.in_groups(2).each_with_index.each do |products_group, index|
      products_group.each do |product|
        product["percent_#{brands[index]}"] = product.delete("t_comparative_percent")
        product["price_#{brands[index]}"] = product.delete("t_comparative_price")
        product["total_#{brands[index]}"] = product.delete("t_comparative_total")
        product["price_percent_#{brands[index]}"] = product.delete("t_comparative_price_with_percent")
        product["total_percent_#{brands[index]}"] = product.delete("t_comparative_total_with_percent")
      end
    end
    products
  end

  private

  def products_only_comparative_format
    products = group_products(format_products).deep_stringify_keys["quotation_products"]
    products.map do |product|
      ["supranet", "siemon"].each do |brand_name|
        product["percent_#{brand_name}"] = product.delete("t_#{brand_name}_only_percent")
        product["price_#{brand_name}"] = product.delete("t_#{brand_name}_only_price")
        product["total_#{brand_name}"] = product.delete("t_#{brand_name}_only_total")
        product["price_percent_#{brand_name}"] = product.delete("t_#{brand_name}_only_price_with_percent")
        product["total_percent_#{brand_name}"] = product.delete("t_#{brand_name}_only_total_with_percent")
      end
    end
    products
  end

  def products_only_single_brand_format
    products = format_products.deep_stringify_keys["quotation_products"]
    products.map do |product|
      product["percent"] = product.delete("#{quotation_type}_percent")
      product["price"] = product.delete("#{quotation_type}_price")
      product["total"] = product.delete("#{quotation_type}_total")
      product["price_percent"] = product.delete("#{quotation_type}_price_with_percent")
      product["total_percent"] = product.delete("#{quotation_type}_total_with_percent")
    end
    products
  end

  def format_services
    data = {
      quotation_services: [],
      services_totals: { with_percent: 0, without_percent: 0 }
    }

    services_data = Service.with_deleted
    .joins(:quotation_services)
    .where("quotation_services.quotation_id"=>id)
    .select(
      "services.deleted_at",
      "services.id as service_id",
      "quotation_services.id",
      "quotation_services.amount",
      "quotation_services.percent",
      "services.price",
      "concat(services.name,' ',services.description) as service"
    ).order(name: :asc)

    services_data.each do |sd|
      # Calculating results
      total_without_percent = sd.amount * sd.price
      unit_price_with_percent = (sd.price * (1 + sd.percent / 100)).round(2)
      total_with_percent = unit_price_with_percent * sd.amount
      # Pushing Results to Hash
      data[:quotation_services].push(
        sd.attributes.merge(
          total: total_without_percent,
          price_with_percent: unit_price_with_percent,
          total_with_percent: total_with_percent
        )
      )
      data[:services_totals][:with_percent] += total_with_percent
      data[:services_totals][:without_percent] += total_without_percent
    end
    data
  end

  def format_products
    data = {
      quotation_products: [],
      products_totals: { with_percent: 0, without_percent: 0 }
    }

    quotation_products.each do |quotation_product|
      # Getting the data
      product = Product.with_deleted.find(quotation_product.product_id)
      # Getting the price that was active when the product was added to the quotation
      unit_price = find_product_price(product.id, quotation_product.created_at)
      amount = quotation_product.amount
      material = product.material
      percent = quotation_product.percent

      # Calculating results
      total_without_percent = amount * unit_price
      unit_price_with_percent = (unit_price * (1 + percent / 100)).round(2)
      total_with_percent = unit_price_with_percent * amount

      # We add the measure unit only if it is not 'Unit'
      measure_unit_name = ''
      unless product.measure_unit.is_unit?
        measure_unit_name = "#{product.measure_unit.name.pluralize} #{I18n.t('of')} "
      end
      material_name = "#{measure_unit_name}#{material.name} #{material.description}"

      # Pushing results to the hash
      data[:quotation_products].push(quotation_product.attributes.merge(
        code: product.code,
        measure_unit_id: product.measure_unit.id,
        material_id: material.id,
        material: material_name,
        brand: product.brand.name,
        deleted_at: product.deleted_at,
        "#{quotation_type}_percent": percent,
        "#{quotation_type}_price": unit_price,
        "#{quotation_type}_total": total_without_percent,
        "#{quotation_type}_price_with_percent": unit_price_with_percent,
        "#{quotation_type}_total_with_percent": total_with_percent
      ))
      data[:products_totals][:with_percent] += total_with_percent
      data[:products_totals][:without_percent] += total_without_percent
    end
    data
  end

  # Groups entries to be shown in 2 columns per row on the view, The entries
  # are only grouped if the brand is either siemon or supranet and the material 
  # and measure units are the exact same
  def group_products(data)
    products = data[:quotation_products]
    products_totals = {
      "t_siemon_only"=>{with_percent: 0, without_percent: 0},
      "t_supranet_only"=>{with_percent: 0, without_percent: 0}
    }
    grouped_products = []
    brands = ['siemon', 'supranet']
    products.in_groups(2).each_with_index.each do |products_group, index|

      products_group.each_with_index do |product, j|
        product_data = {}
        if index == 0
          grouped_products.push(product_data)
        else
          product_data = grouped_products[j]
        end

        product.each do |key, value|
          new_key = key.to_s.gsub('t_comparative', "t_#{brands[index]}_only")
          product_data[new_key] = value unless product_data[new_key]
        end

        products_totals["t_#{brands[index]}_only"][:without_percent] += product[:t_comparative_total]
        products_totals["t_#{brands[index]}_only"][:with_percent] += product[:t_comparative_total_with_percent]
      end
    end
    { quotation_products: grouped_products,products_totals: products_totals }
  end

  def find_product_price(product_id,creation_date)
    Price.with_deleted
    .joins("INNER JOIN products ON products.id = prices.product_id")
    .where(product_id: product_id)
    .where("prices.deleted_at >= '#{creation_date}' OR prices.deleted_at is null")
    .select(:product_price)
    .order(:deleted_at)
    .limit(1)[0].product_price
  end

end
