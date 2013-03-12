require 'nokogiri'
require 'open-uri'
require 'mechanize'
require 'pp'

class Fit
  def initialize(year, make, model, engine)
    @year = year
    @make = make
    @model = model
    @engine = engine
    @enter_url = "http://www.autozone.com/autozone/ymme/selector.jsp"
    @product_url = "http://www.autozone.com/autozone/parts/Duralast-Brake-Rotor-Rear/_/N-8knrr?itemIdentifier=186287_0_0_"
 
    @make_page  
    @agent = Mechanize.new
    @agent.user_agent_alias = 'Windows IE 9'


  end
  
  def link_year

    page_result = @agent.get(@enter_url) 
    link =  page_result.links.find{|l| l.text.strip == @year.to_s } 
    pp link

    link.text.strip
  end

  def link_make
    page_result = @agent.get(@enter_url)
    make_page = page_result.links.find { |l| l.text.strip == @year.to_s}.click
    link = make_page.links.find{|l| l.text.strip == "Acura"}
    pp link
    #from 2-> -1 
    #pp make_page.links[2]
    #pp make_page.links[-1]
    link.text.strip
  end

  def link_model
    page_result = @agent.get(@enter_url)
    make_page = page_result.links.find { |l| l.text.strip == @year.to_s}.click

    model_page = make_page.links.find {|l| l.text.strip == "Acura"}.click
    pp make_page.links[2]

    link = model_page.links.find{|l| l.text.strip == "ILX"}
    pp  link

    link.text.strip
    
  end

  def link_engine
    page_result = @agent.get(@enter_url)
    make_page = page_result.links.find { |l| l.text.strip == @year.to_s}.click

    model_page = make_page.links.find {|l| l.text.strip == @make.to_s }.click

    engine_page = model_page.links.find{ |l| l.text.strip == @model.to_s }.click

    #pp make_page.links.find {|l| l.text.strip == @make.to_s }
    #pp model_page.links.find{ |l| l.text.strip == @model.to_s }
    #pp engine_page.links[4]

    link = engine_page.links[4]#.find{|l| l.text.strip == "4 Cylinders 2.0L MFI SOHC"}
    #pp  link
   
    link.text.strip
  end
  
  def fit_product
    page_result = @agent.get(@enter_url)
    make_page = page_result.links.find { |l| l.text.strip == @year.to_s}.click

    model_page = make_page.links.find {|l| l.text.strip == @make.to_s }.click

    engine_page = model_page.links.find{ |l| l.text.strip == @model.to_s }.click

#    pp make_page.links.find {|l| l.text.strip == @make.to_s }
#    pp model_page.links.find{ |l| l.text.strip == @model.to_s }
#    pp engine_page.links[4]

    select_car = engine_page.links[4].click
   
    @agent.get(engine_page.links[4].href)
    page_new = @agent.get(@product_url) 
    #pp page_new.search("//div[@class = 'wrapper']")
    #page_new.search("//div[@class = 'wrapper']") #return []

	
    page_new.links.find{|l| l.text.strip == 'View similar parts that fit your vehicle'}
   
  end


end

#Fit.new(2013).link_txt
