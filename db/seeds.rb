# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
user = User.create(email: 'admin@lomax.com.gt',password: 'lomax123', password_confirmation: 'lomax123', role: User.roles[:administrador])
UserDetail.create(name: 'Administrador', last_name: 'Lomax', user: user)

brands = %w[Genérica Siemon Supranet]
brands.each do |name|
  Brand.create(name: name)
end

MeasureUnit.create(name:'Unidad',unit_type: 'Unidad')
MeasureUnit.create(name:'Metro',unit_type: 'Longitud')
MeasureUnit.create(name:'Pie',unit_type: 'Longitud')
MeasureUnit.create(name:'Bobina',unit_type: 'Longitud')
