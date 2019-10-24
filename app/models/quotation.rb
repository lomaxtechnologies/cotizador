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
    attributes.slice("warranty", "payment_condition", "credits")
  end

  def header_only
    attributes.slice("client_id","quotation_date","quotation_type")
  end

  def services_only
    quotation_services.map do |quotation_service|
      service = quotation_service.service
      amount = quotation_service.amount
      price = service.price
      percent = quotation_service.percent
      {
        id: quotation_service.id,
        amount:amount,
        percent: percent,
        service_id: service.id,
        price: price,
        name: service.name,
        tot_without_perc: amount * price,
        tot_with_perc: (price * (1 + percent / 100)).round(2) * amount
      }
    end
  end

  def products_only
    if t_comparative?
      products_only_comparative_format
    else
      products_only_single_brand_format
    end
  end

  private

  def products_only_single_brand_format
    products = format_products["quotation_products"]
    products.map do |product|
      product["percent"] = product.delete("#{quotation_type}_percent")
      product["price"] = product.delete("#{quotation_type}_price")
      product["total"] = product.delete("#{quotation_type}_total")
      product["price_percent"] = product.delete("#{quotation_type}_price_with_percent")
      product["total_percent"] = product.delete("#{quotation_type}_total_with_percent")
      product["material_id"] = product.delete("product_id")
    end
    products
  end

  def format_services
    data = {
      quotation_services: [],
      services_totals: {
        with_percent: 0,
        without_percent: 0
      }
    }

    quotation_services.each do |quotation_service|
      # Getting the data
      service = quotation_service.service
      unit_price = service.price
      amount = quotation_service.amount
      percent = quotation_service.percent

      # Calculating results
      total_without_percent = amount * unit_price
      unit_price_with_percent = (unit_price * (1 + percent / 100)).round(2)
      total_with_percent = unit_price_with_percent * amount

      # Pushing Results to Hash
      data[:quotation_services].push(
        amount: amount,
        service: "#{service.name} #{service.description}",
        percent: percent,
        price: unit_price,
        total: total_without_percent,
        price_with_percent: unit_price_with_percent,
        total_with_percent: total_with_percent
      )
      data[:services_totals][:with_percent] += total_with_percent
      data[:services_totals][:without_percent] += total_without_percent
    end
    data.deep_stringify_keys
  end

  def format_products
    data = {
      quotation_products: [],
      products_totals: {
        with_percent: 0,
        without_percent: 0
      }
    }

    quotation_products.each do |quotation_product|
      # Getting the data
      product = quotation_product.product
      unit_price = product.price.product_price
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
        "#{quotation_type}_percent": percent,
        "#{quotation_type}_price": unit_price,
        "#{quotation_type}_total": total_without_percent,
        "#{quotation_type}_price_with_percent": unit_price_with_percent,
        "#{quotation_type}_total_with_percent": total_with_percent
      ))
      data[:products_totals][:with_percent] += total_with_percent
      data[:products_totals][:without_percent] += total_without_percent
    end
    data.deep_stringify_keys
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

      if %w[siemon supranet].include? brand_name
        # When the brand is siemon or supranet, we push the prices 1 time
        p.each do |key, value|
          new_data[key.to_s.gsub('t_comparative', "t_#{brand_name}_only")] = value
        end
        products_totals["t_#{brand_name}_only"][:without_percent] += p[:t_comparative_total]
        products_totals["t_#{brand_name}_only"][:with_percent] += p[:t_comparative_total_with_percent]
      else
        # When the brand is not siemon or supranet, we push the prices 2 times,
        # so it appears in both columns on the views
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

end
