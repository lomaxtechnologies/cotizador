class Client < ApplicationRecord
  acts_as_paranoid
  has_many :quotations
  validates :name, presence: true
  paginates_per 10

  # Returns all the clients, but only the id, name. The nit is included on the name
  def self.list_all
    data = []
    clients = Client.select(:id, :name, :nit).all
    clients.each do |client|
      data.push(id: client.id, name: "#{client.name}, nit: #{client.nit}")
    end
    data
  end
end
