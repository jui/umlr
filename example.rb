require 'umlr'


model :route do
  property :id, "String"
  property :name, "String"
end

model :stop do
  property :id
  property :latitude
  property :longitude
end

model :drive do
  property :id
  property :start_time
end

many_to_many :route => :stop

one_to_many :drive => :route

one_to_one "Label", :drive => :stop


Umlr.generate_png("my.png")


