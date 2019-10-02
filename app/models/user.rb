class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :registerable, :trackable and :omniauthable, :lockable
  devise :database_authenticatable, :timeoutable, :recoverable, :rememberable, :validatable
  acts_as_paranoid
  has_one :user_detail
  has_many :quotations
  has_many :attachments
  has_many :comments
  has_one_attached :avatar
  validate :correct_avatar_file_type

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

  def generate_password
    SecureRandom.base64(16)
  end

  def update_own_account(user_params)
    if user_params[:password].empty?
      user_params = user_params.except(:password, :password_confirmation)
    end
    update(user_params)
  end

  def generate_and_reset_password
    new_password = generate_password
    return false unless reset_password(new_password,new_password)

    UserMailer.password_reset_email(self).deliver
    return true
  end

  private

  def correct_avatar_file_type
    if avatar.attached? && !avatar.content_type.in?(['image/png', 'image/gif', 'image/jpg', 'image/jpeg'])
      errors.add(:avatar, :invalid_file_type)
    end
  end

end
