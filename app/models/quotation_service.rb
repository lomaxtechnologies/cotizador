class QuotationService < ApplicationRecord
    belongs_to :quotation
    belongs_to :service
end
