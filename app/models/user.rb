class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :registerable, :trackable and :omniauthable
  devise :database_authenticatable, :lockable, :timeoutable, :recoverable, :rememberable, :validatable
  acts_as_paranoid
  has_one :user_detail
  has_many :quotations
  has_many :attachments
  has_many :comments

  paginates_per 10

  # All the possible roles are stored in this class variable
  enum role: [:Administrador, :Consulta]

  validates :role, presence: true, inclusion: { in: :role }

  def create_user(user_detail)
    user_detail.user = self
    save
  end

  def update_user(user_params,user_detail_params)
    ActiveRecord::Base.transaction do
      if update(user_params)
        return true if user_detail.update(user_detail_params)
      end
      raise ActiveRecord::Rollback
    end
  end

  def destroy_user
    ActiveRecord::Base.transaction do
      if user_detail.destroy
        return true if destroy
      end
      raise ActiveRecord::Rollback
    end
  end
end
