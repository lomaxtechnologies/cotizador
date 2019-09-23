class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :registerable, :trackable and :omniauthable
  devise :database_authenticatable, :lockable, :timeoutable,
         :recoverable, :rememberable, :validatable

  belongs_to :role

  def save_user(user_detail)
    ActiveRecord::Base.transaction do
      self.save
      user_detail.user = self
      user_detail.save
    end
  end
  
end
