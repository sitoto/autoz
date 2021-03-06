require 'spec_helper'

describe Fit do 
=begin	
 context "Year" do
    it "2013" do
      fit = Fit.new("2013")
      fit.link_year.should == "2013"
    end
 end

 context "Make" do 
    it "Acura" do
      fit = Fit.new("2013")
      fit.link_make.should == "Acura"
     end
 end	

  context "Model" do 
    it "ILX" do 
      fit = Fit.new("2013")
      fit.link_model.should == "ILX"
    end
  end
=end  
#http://www.autozone.com/autozone/parts/Duralast-Brake-Rotor-Rear/_/N-8knrr?itemIdentifier=186287_0_0_
  context "Engine" do 
    it "4 Cylinders 2.0L MFI SOHC" do
      fit = Fit.new("2013", "Acura", "ILX", "4 Cylinders   2.0L MFI SOHC")
      fit.link_engine.should == "4 Cylinders   2.0L MFI SOHC"
    end

    it "4 Cylinders F 2.2L SFI DOHC" do 
      fit = Fit.new("2004", "Chevrolet", "Malibu Classic", "4 Cylinders F 2.2L SFI DOHC")
      fit.link_engine.should == "4 Cylinders F 2.2L SFI DOHC"
    end

  end

  context "Fit Product" do 
    it "4 Cylinders 2.0L MFI SOHC" do
      fit = Fit.new("2013", "Acura", "ILX", "4 Cylinders   2.0L MFI SOHC")
      fit.fit_product.should be_true 
    end

    it "4 Cylinders F 2.2L SFI DOHC" do 
      fit = Fit.new("2004", "Chevrolet", "Malibu Classic", "4 Cylinders F 2.2L SFI DOHC")
      fit.fit_product.should be_false 
    end

  end
end
