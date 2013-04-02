class Product
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :part_no
  field :alternate_part_no
  
  field :specification, 	type: String  #记录产品详细页内容
  
  field :product_url, 	type: String  #产品详细页面的地址
end

