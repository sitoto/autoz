class Product
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :part_no
  field :alternate_part_no
  field :price
  
  field :year,  :type => String
  field :maker, :type => String
  field :model, :type => String
  field :engine, :type => String
  
  
  field :specification, 	type: String  #记录产品详细页内容
  
  field :product_url, 	type: String  #产品详细页面的地址
  field :car_url, 	type: String  #选中车的详细地址
  
  embeds_many  :parameters
end

