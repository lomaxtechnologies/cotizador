class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :registerable, :trackable and :omniauthable
  devise :database_authenticatable, :lockable, :timeoutable,
         :recoverable, :rememberable, :validatable

  belongs_to :role
  has_many :quotations
  has_many :attachments
  has_many :comments
end
