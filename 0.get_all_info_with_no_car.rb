#encoding: UTF-8
require 'rubygems'
require 'mongoid'
require 'nokogiri'
require 'open-uri'
require 'logger'
require 'pp'
require 'forkmanager'		# gem install parallel-forkmanager

require_relative 'lists'
require_relative 'file_io'
require_relative 'last_url_items'



Dir.glob("#{File.dirname(__FILE__)}/app/models/*.rb") do |lib|
  require lib
end

#ENV['MONGOID_ENV'] = 'local_dev' 	#127.0.0.1:27017
ENV['MONGOID_ENV'] = 'dev'  		#192.168.2.14:27017

Mongoid.load!("config/mongoid.yml")

class MultipleCrawler

	class Crawler
		def initialize
			
			@logger = Logger.new('log.log', 'daily')
			
		end #end initialize
		
		def safe_open(product_url, retries = 3, sleep_time = 0.42,  headers = {})
			begin  
			  html = Nokogiri::HTML(open(product_url, headers).read)
			  #@agent.get(product_url)
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

		def fetch(product_url)
			safe_open(product_url)
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
	
	def process
		start_time = Time.now
		@pm_max = 10
		pfm = Parallel::ForkManager.new(@pm_max)
		
		@websites.each do  |url, i|
				#next if i < 1332
				
				begin
					pfm.start(url) and next
					puts url
					product_url = url
					page_result = Crawler.new().fetch(product_url)
					status = 0
					next if page_result.nil?
					
					info = Info.new
					
					puts info.part_no =  page_result.at_xpath("//span[@class = 'part-number']").text.strip.split(':')[1].strip
					info.alternate_part_no   = page_result.at_xpath("//span[@class = 'alt-part-number']").text.strip.split(':')[1].strip
					
					info.specification = page_result.at_xpath("//table[@id = 'prodspecs']").to_s
					info.product_url = url
					info.svae
					
					status = 200
				rescue
					#print "Connection to ... had an unspecified error!\n"
					print $!
					pfm.finish(255)
				end # end of begin
				if status.to_i == 200
					pfm.finish(0) # exit the forked process with this status
				else
					pfm.finish(255) # exit the forked process with this status
				end
				#break
			end  # end of  websites
		
		puts "#{'%.4f' % (Time.now - start_time)}s."
	end #end process
	
	
	
end

websites = @last_urls

user_agent = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:13.0) Gecko/20100101 Firefox/13.0'
MultipleCrawler.new(websites, user_agent, @last_urls).process
