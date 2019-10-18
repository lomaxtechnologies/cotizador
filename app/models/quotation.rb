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

  def default_material_percentage
    15
  end

  def self.all_only_identifier_fields
    Quotation.joins(:client).select(
      'quotations.id',
      'quotations.quotation_date',
      'quotations.quotation_type',
      'quotations.state',
      'clients.name'
    )
  end

  def default_service_percentage
    0
  end

  def destroy
    if self.created? || self.expired?
      super
    else
      errors.add(:state, :destroy_impossible)
      false
    end
  end
end
