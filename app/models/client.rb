class Client < ApplicationRecord
  acts_as_paranoid
  has_many :quotations
  validates :name, presence: true
  paginates_per 10

  def save
    if self.nit_changed?
      if Client.exists?(nit: nit)
        errors.add(:nit, :duplicated)
        false
      else
        super
      end
    else
      super
    end
  end
end


