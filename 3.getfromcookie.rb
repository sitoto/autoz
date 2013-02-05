#encoding: UTF-8
require 'rubygems'
require 'mechanize'
require 'pp'


#构建agent
agent = Mechanize.new
url = 'http://www.autozone.com/autozone/parts/Duralast-Brake-Rotor-Front/_/N-8knrq?itemIdentifier=523171_0_0_'
#获取页面
	page_old = agent.get(url)
	pp agent.cookies
	puts car_url = page_old.links.find { |l| l.text.strip == 'Add a Vehicle' }.href
	page_car = agent.get(car_url)
	pp agent.cookies
	year_page = page_car.links.find { |l| l.text.strip == '2013' }.click
	
	maker_page = year_page.links.find { |l| l.text.strip == 'Acura' }.click
	model_page = maker_page.links.find { |l| l.text.strip == 'ILX' }.click
	pp model_page
	puts engine_url = model_page.links.last.href #find { |l| l.text == "4 Cylinders 2.0L MFI SOHC" }.href
	engine_page = agent.get(engine_url)
	
	page_new = agent.get(url)
	puts page_new.search("//title")
	puts page_new.links.find{|l| l.text.strip == 'View similar parts that fit your vehicle'}.href
	pp page_new.search("//div[@class = 'wrapper']")
	
	
return

brake_page_1 = search_result.links.find { |l| l.text.strip == 'Brake Rotor - Front' }.click
cookie.domain = "www.autozone.com"
cookie.path = "/"
agent.cookie_jar.add(URI.parse("http://www.autozone.com/"), cookie)
puts agent.cookies.to_s

#获取页面
page = agent.get(url)
puts agent.cookies.to_s

puts page.search("//title")

#page.search("#leftsidebar a").each do |a|
#	puts  u = a["href"]
#end


#class = mbYMME
#pp page
#pp page.links.find { |l| l.text.strip == 'View similar parts that fit your vehicle'}#.href #'View similar parts that fit your vehicle' }

#page.search("//title")#("//div[@class='thumb-box']/div[@class='thumb']/a/@href")

return

a.get('http://www.autozone.com/autozone/') do |page|
  search_result = page.form_with(:name => 'searchformlet') do |search|
    search.searchText = '55083'
  end.submit
	
  brake_page_1 = search_result.links.find { |l| l.text.strip == 'Brake Rotor - Front' }.click
  brake_page_2 = brake_page_1.links.find { |l| l.text.strip == 'Duralast/Brake Rotor - Front' }#.click
  
  puts detail_url  =  brake_page_2.href
  
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
cookie.domain = '.autozone.com'
cookie.path = '/'
agent.cookie_jar.add(URI.parse("http://www.youku.com/"), cookie)

page = agent.get(detail_url, :referer => "http://www.youku.com/")
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


