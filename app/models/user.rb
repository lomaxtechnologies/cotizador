class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :registerable, :trackable and :omniauthable, :lockable
  devise :database_authenticatable, :timeoutable, :recoverable, :rememberable, :validatable
  acts_as_paranoid
  has_one :user_detail
  has_many :quotations
  has_many :attachments
  has_many :comments

  accepts_nested_attributes_for :user_detail, update_only: true

  paginates_per 10

  # All the possible roles are stored in this class variable
  enum role: [:administrador, :consultor]

  validates :role, presence: true, inclusion: { in: :role }

  def self.valid_role?(role)
    User.roles.keys.include?(role)
  end

  def self.create_user(user_params)
    if User.valid_role? user_params[:role]
      user = User.new(user_params)
      user.save
    else
      user = User.new
      user.errors.add(:role, :does_not_exist)
    end
    user
  end

end
