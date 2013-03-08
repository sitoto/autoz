require 'spec_helper'

describe Fit do 
 context "Year" do
    it "2013" do
      fit = Fit.new("2013")
      fit.link_year.should == "2013"
    end
 end

end
