class QuotationProduct < ApplicationRecord
  belongs_to :quotation
  belongs_to :product
end
