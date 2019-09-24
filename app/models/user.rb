class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :registerable, :trackable and :omniauthable
  devise :database_authenticatable, :lockable, :timeoutable,
         :recoverable, :rememberable, :validatable

  belongs_to :role
  has_one :user_detail

  def create_user(user_detail)
    user_detail.user = self
    ActiveRecord::Base.transaction do
      if self.save
        if user_detail.save
          return true
        end
      end
      raise ActiveRecord::Rollback
      return false
    end
  end

  def update_user(user_params,user_detail_params)
    ActiveRecord::Base.transaction do
      if self.update(user_params)
        if self.user_detail.update(user_detail_params)
          return true
        end
      end
      raise ActiveRecord::Rollback
      return false
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
      return false
    end
  end
end
