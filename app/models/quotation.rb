class Quotation < ApplicationRecord
  acts_as_paranoid
  belongs_to :client
  belongs_to :user
  has_many :quotation_products
  has_many :quotation_services
  has_many :attachments
  has_many :quotations_notes
  has_many :comments, as: :commentable
  accepts_nested_attributes_for :quotation_products
  accepts_nested_attributes_for :quotation_services
  has_many_attached :files

  # All the possible quotation types
  enum quotation_type: [:t_comparative,:t_siemon_only,:t_supranet_only,:t_simple]
  validates :quotation_type, presence: true, inclusion: { in: :quotation_type }

  # All possible states
  enum state: [:created, :active, :accepted, :expired]
  validates :state, presence: true, inclusion: {in: :state}

  paginates_per 10
  
  scope :type, -> (params) {select(:quotation_type).where(id: params[:id])}

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

  # Returns a hash with client information, and detailed products and
  # services information
  def detailed_info
    data = attributes
    .merge(client: client)
    .merge(format_products)
    .merge(format_services)
    data
  end

  private

  def format_services
    data = {
      quotation_services: [],
      services_totals: {
        with_percent: 0,
        without_percent: 0
      }
    }

    quotation_services.each do |quotation_service|
      #Getting the data
      service = quotation_service.service
      unit_price = service.price
      amount = quotation_service.amount
      percent = quotation_service.percent

      #Calculating results
      total_without_percent = amount * unit_price
      unit_price_with_percent = unit_price * (1 + percent / 100)
      total_with_percent = unit_price_with_percent * amount

      #Pushing Results to Hash
      data[:quotation_services].push(
        amount: amount,
        service: "#{service.name} #{service.description}",
        price: unit_price,
        total: total_without_percent,
        price_with_percent: unit_price_with_percent,
        total_with_percent: total_with_percent
      )
      data[:services_totals][:with_percent] += total_with_percent
      data[:services_totals][:without_percent] += total_without_percent
    end
    data
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
      #Getting the data
      product = quotation_product.product
      unit_price = product.price.product_price
      amount = quotation_product.amount
      percent = quotation_product.percent

      #Calculating results
      total_without_percent = amount * unit_price
      unit_price_with_percent = unit_price * (1 + percent / 100)
      total_with_percent = unit_price_with_percent * amount

      #pushing results to the hash
      data[:quotation_products].push(quotation_product.attributes.merge(
        material: "#{product.material.name} #{product.material.description}",
        brand: product.brand.name,
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

end
