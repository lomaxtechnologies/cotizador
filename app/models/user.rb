class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :registerable, :trackable and :omniauthable
  devise :database_authenticatable, :lockable, :timeoutable,
         :recoverable, :rememberable, :validatable
end
