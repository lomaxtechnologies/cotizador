FactoryBot.define do
  factory :role do
    name {"MyFactoryRoleName"}
  end
  
  factory :user do
    email { "email@temporal.com" }
    password { "password"} 
    password_confirmation { "password" }
    role_id {Role.first.id}
  end

  
end
