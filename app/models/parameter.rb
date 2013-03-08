class Parameter
  include Mongoid::Document
  
  field :name, :type => String
  field :value, :type => String


  embedded_in :product
end