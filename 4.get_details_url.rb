#encoding: UTF-8
require 'rubygems'
require 'mongoid'
require 'nokogiri'
require 'open-uri'
require 'logger'
require 'pp'
require 'mechanize'  #用来模拟用户、浏览器行为

require_relative 'lists'
require_relative 'file_io'
require_relative 'last_url_items'



Dir.glob("#{File.dirname(__FILE__)}/app/models/*.rb") do |lib|
  require lib
end

#ENV['MONGOID_ENV'] = 'local_dev' 	#127.0.0.1:27017
ENV['MONGOID_ENV'] = 'dev'  		#211.101.12.237:27017

Mongoid.load!("config/mongoid.yml")

class MultipleCrawler

	class Crawler
		def initialize
			@agent = Mechanize.new
			@agent.max_history = 4 
			@agent.user_agent_alias = "Windows IE 9"
			

			@logger = Logger.new('log.log', 'daily')
			
		end #end initialize
		
		def safe_open(select_car_url, product_url, retries = 3, sleep_time = 0.42,  headers = {})
			begin  
			  @agent.get(select_car_url)
			  @agent.get(product_url)
			rescue StandardError,Timeout::Error, SystemCallError,Mechanize::ResponseCodeError, Errno::ECONNREFUSED #有些异常不是标准异常  
			  puts $!  
			  retries -= 1  
			  if retries > 0  
				sleep sleep_time and retry  
			  else  
				@logger.error($!)
				nil
			  end  
			end
		end	# end of safe_open

		def fetch(select_car_url, product_url)
			safe_open(select_car_url, product_url)
		end
	end # end class Crawler
	
	def create_file_to_write(name)
		file_path = File.join('.', "#{name}-#{Time.now.to_formatted_s(:number) }.txt")
		@file_to_write = IoFactory.init(file_path)
	end	
	def initialize(websites, name, last_urls)
		@websites = websites
		@user_agent = name
		@last_urls = last_urls
		create_file_to_write("autozone")
	end
	
	#处理采集的参数
	def process
		start_time = Time.now
		
		# 一个验证 提交一次，
		
		# not fit
		#select_car_url = "http://www.autozone.com/autozone/ymme/selector.jsp;jsessionid=B10B361606FD0DB6084BBBB62AF372F6.diyprod2-b2c4?ymme=32184001"
		#product_url  = "http://www.autozone.com/autozone/parts/Duralast-Brake-Rotor-Rear/_/N-8knrr?itemIdentifier=186287_0_0_"
		# end not fit
		
		# fit
product_url = "http://www.autozone.com/autozone/parts/Duralast-Brake-Rotor-Rear/_/N-8knrr?itemIdentifier=112433_0_0_"
#		product_url  = "http://www.autozone.com/autozone/parts/Duralast-Brake-Rotor-Rear/_/N-8knrr?itemIdentifier=186287_0_0_"
		# end fit
		1998.downto(1985) do |y|
		y = y.to_s 
		cars = Car.where(year: y)
		max_cars =  cars.length
		cars.each_with_index do |car, i|
			#next if i < 1332
			select_car_url = car.ymme
			page_result = Crawler.new().fetch(select_car_url, product_url)
			next if page_result.nil?
			
			if page_result.links.find{|l| l.text.strip == 'View similar parts that fit your vehicle'}
				puts s1 =  "#{y}/#{i}/#{max_cars}\t not  fit"
				@file_to_write.puts s1
				
			elsif page_result.search("//img[@id = 'bannerRightPart']").length > 0
				puts s1 =  "#{y}/#{i}/#{max_cars}\t no vehicle"
				@file_to_write.puts  "#{y}\t#{i}\t#{product_url}\t#{select_car_url}"
				
				product = Product.new
				product.part_no = "no vehicle"
				product.product_url = product_url
				product.car_url = select_car_url
				product.save
				
			else #if page_result.search("//div[@class = 'wrapper']").length > 0
				#save this fit result
				puts s1 =  "#{y}/#{i}/#{max_cars}\t fit"
				@file_to_write.puts s1
				puts part_no =  page_result.search("//span[@class = 'part-number']").text.strip
				puts alternate_part_no   = page_result.search("//span[@class = 'alt-part-number']").text.strip

				product = Product.new
				product.part_no = part_no
				product.alternate_part_no = alternate_part_no
				product.year = car.year
				product.maker = car.maker
#				product.type  = 
				product.model = car.model
				product.engine = car.engine
				product.product_url = product_url
				product.car_url = select_car_url
				#product.tip = "autozone"
				
				product.save
			#else
			#	@file_to_write.puts "some other unknow result!!!!"
			end
			#break
			end #end of years
		end
puts "#{'%.4f' % (Time.now - start_time)}s."
	end #end process
	
	
	
end

websites = "http://www.autozone.com/autozone/ymme/selector.jsp"

user_agent = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:13.0) Gecko/20100101 Firefox/13.0'
MultipleCrawler.new(websites, user_agent, @last_urls).process
