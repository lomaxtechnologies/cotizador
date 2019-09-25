class Quotation < ApplicationRecord
    belongs_to :client
    belongs_to :user
    has_many :quotation_products
    has_many :quotation_services
    has_many :attachments
    has_many :quotations_notes
    has_many :comments, as: :commentable
end
