class Attachment < ApplicationRecord
  acts_as_paranoid
  belongs_to :quotation
  belongs_to :user

  has_one_attached :location
end
