# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
user = User.create(email: 'admin@lomax.com.gt',password: 'lomax123', password_confirmation: 'lomax123', role: User.roles[:administrador])
UserDetail.create(name: 'Administrador', last_name: 'Lomax', phone: '(502) 2296 6131', user: user)

brands = %w[Ninguna Siemon Supranet]
brands.each do |name|
  Brand.create(name: name)
end

MeasureUnit.create(name:'Metro',unit_type: 'Longitud')
MeasureUnit.create(name:'Pie',unit_type: 'Longitud')
MeasureUnit.create(name:'Bobina',unit_type: 'Longitud')
MeasureUnit.create(name:'Unidad',unit_type: 'Unidad')

Client.create(name:'Cliente de prueba')
Quotation.create(code:101, quotation_date:'15/10/2019',client:Client.first,user: User.first, quotation_type: Quotation.quotation_types[:t_comparative])