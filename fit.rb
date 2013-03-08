require 'nokogiri'
require 'open-uri'
require 'mechanize'
require 'pp'

class Fit
  def initialize(year)
    @year = year
    @enter_url = "http://www.autozone.com/autozone/ymme/selector.jsp"

  end
  
  def link_year
    agent = Mechanize.new
    agent.user_agent_alias = 'Windows IE 9'

    page_result = agent.get(@enter_url) 
    link =  page_result.links.find{|l| l.text.strip == "2013" } 
    pp link
    puts "http://www.autozone.com#{link.href}"
    link.text.strip
  end
end

#Fit.new(2013).link_txt
