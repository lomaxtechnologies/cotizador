class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :registerable, :trackable and :omniauthable
  devise :database_authenticatable, :lockable, :timeoutable, :recoverable, :rememberable, :validatable
  has_one :user_detail

  has_many :quotations
  has_many :attachments
  has_many :comments
  
  @@roles = {
    1 => "Administrador"
  }

  validates :role, presence: true, inclusion: {in: @@roles}

  def self.roles
    return @@roles
  end

  def self.role_index_to_string(role)
    begin
      role = @@roles[role]
      if role
        return role
      end
    rescue TypeError
    end
    return ""
  end

  def create_user(user_detail)
    user_detail.user = self
    return self.save
  end

  def update_user(user_params,user_detail_params)
    ActiveRecord::Base.transaction do
      if self.update(user_params)
        if self.user_detail.update(user_detail_params)
          return true
        end
      end
      raise ActiveRecord::Rollback
    end
  end

  def destroy_user
    ActiveRecord::Base.transaction do
      if self.user_detail.destroy
        if self.destroy
          return true
        end
      end
      raise ActiveRecord::Rollback
    end
  end

end
