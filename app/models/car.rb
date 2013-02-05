class Car
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :year
  field :maker, 	type: String
  field :model, 	type: String
  field :engine, 	type: String
  field :tip, 		type: String		#example: "autozone" , "aap", "bitauto"
  field :ymme						# autozone's number for this car
  
end

