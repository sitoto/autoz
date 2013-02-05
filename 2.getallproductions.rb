#encoding: UTF-8
require 'rubygems'
require 'mechanize'
require 'nokogiri'
require 'pp'

require_relative 'auto_no'
require_relative 'file_io'

a = Mechanize.new { |agent|
  agent.user_agent_alias = 'Mac Safari'
}

def create_file_to_write(name)
	file_path = File.join('.', "#{name}-1.txt")
	@file_to_write = IoFactory.init(file_path)
end
create_file_to_write("autozone")

a.get('http://www.autozone.com/autozone/') do |page|
  search_result = page.form_with(:name => 'searchformlet') do |search|
    search.searchText = '55036'
  end.submit
	
  brake_page_1 = search_result.links.find { |l| l.text.strip == 'Brake Rotor - Front' }.click
  brake_page_2 = brake_page_1.links.find { |l| l.text.strip == 'Duralast/Brake Rotor - Front' }.click
  
  #brake_page_2
  
#车型：		2009 Chevrolet Cobalt 2.2L MFI DOHC 4cyl
#Part_No:	55083  
#失败  
#http://www.autozone.com/autozone/parts/Duralast-Brake-Rotor-Front/_/N-8knrq?itemIdentifier=523171_0_0_
#成功
#http://www.autozone.com/autozone/parts/Duralast-Brake-Rotor-Front/_/N-8knrq?itemIdentifier=560440_0_0_  

#cookie = Mechanize::Cookie.new(key, value)
#cookie.domain = ".oddity.com"
#cookie.path = "/"
#agent.cookie_jar.add(agent.history.last.uri, cookie)
agent = Mechanize.new
agent.user_agent_alias = 'Windows IE 9'
agent.follow_meta_refresh = true
#agent.log = Logger.new(STDOUT)

cookie = Mechanize::Cookie.new("__utmarea", "404-0-1")
cookie.domain = '.youku.com'
cookie.path = '/'
agent.cookie_jar.add(URI.parse("http://www.youku.com/"), cookie)

page = agent.get("http://www.autozone.com/autozone/")
puts agent.cookies.to_s


#puts brake_page_2.cookies.to_s
  
  #puts brake_page_2.search("//title")#("//div[@class='thumb-box']/div[@class='thumb']/a/@href")
  
  #brake_page.links.each do |link|
  #  puts link.text
  #end
  #brake_page.each do |item|
#	@file_to_write.puts	item
#  end
  
  
  #@doc = Nokogiri::HTML(brake_page)
  
  #puts brake_page.link_with(:dom_class => "links_exact_class")
end