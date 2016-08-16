require 'mongoid'

Mongoid.configure.connect_to("mongoid_test")


class Album
	include Mongoid::Document
	include Mongoid::Timestamps
	include Mongoid::Attributes::Dynamic


	field :name, type: String
	field :country, type: String
	field :price,type:Float
end

names=%w(A1 A2 A3)
countries=%w(C1 C2 C3)

for i in 0...10000 do
 Album.create(name: names[rand(3)],country: countries[rand(3)],price: rand(100))
end
