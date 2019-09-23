json.extract! service, :id, :name, :description, :creation_price, :actual_price, :creator_user, :modifier_user, :status, :created_at, :updated_at
json.url service_url(service, format: :json)
