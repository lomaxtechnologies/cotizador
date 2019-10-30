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
    attributes.slice("client_id","quotation_date","quotation_type")
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
      if t_simple?
        product["material_id"] = product.delete("product_id")
      end
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

      # Pushing results to the hash
      data[:quotation_products].push(quotation_product.attributes.merge(
        code: product.code,
        measure_unit_id: product.measure_unit.id,
        material_id: material.id,
        material: "#{material.name} #{material.description}",
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
    grouped_products = {}
    products.each do |p|
      # To group the same product in different both brands an ID is generated.
      # That ID will be made of the material id and the measure unit id.
      id = "#{p[:material_id]}_#{p[:measure_unit_id]}"
      new_data = grouped_products[id] || {}
      brand_name = p[:brand].downcase

      # These 3 lines helps the frontend associate a product_id when the brand is not siemon or supranet
      brand_name_tag = brand_name == "siemon" ? brand_name : "supranet"
      p["#{brand_name_tag}_id"] = p["product_id"];
      p["quotation_product_#{brand_name_tag}_id"] = p.delete("id");

      if grouped_products[id]
        # If the key exists, one brand is there alredy, so we push only once
        p.each do |key, value|
          new_data[key.to_s.gsub('t_comparative', "t_#{brand_name}_only")] = value
        end
        products_totals["t_#{brand_name}_only"][:without_percent] += p[:t_comparative_total]
        products_totals["t_#{brand_name}_only"][:with_percent] += p[:t_comparative_total_with_percent]
      else
        # If it does not exists, we push twice
        %w[t_supranet_only t_siemon_only].each do |name|
          p.each do |key, value|
            new_data[key.to_s.gsub('t_comparative', name)] = value
          end
          products_totals[name][:without_percent] += p[:t_comparative_total]
          products_totals[name][:with_percent] += p[:t_comparative_total_with_percent]
        end
      end
      grouped_products[id] = new_data
    end
    { quotation_products: grouped_products.values,products_totals: products_totals }
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
