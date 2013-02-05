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


Dir.glob("#{File.dirname(__FILE__)}/app/models/*.rb") do |lib|
  require lib
end

#ENV['MONGOID_ENV'] = 'local_dev' 	#127.0.0.1:27017
ENV['MONGOID_ENV'] = 'dev'  		#211.101.12.237:27017

Mongoid.load!("config/mongoid.yml")

class MultipleCrawler

	class Crawler
		def initialize(user_agent)
			@user_agent = user_agent

			@logger = Logger.new('log.log', 'daily')
			
		end #end initialize
		attr_accessor :user_agent, :redirect_limit, :timeout
		

		
		def safe_open(url, retries = 5, sleep_time = 0.42,  headers = {})
			begin  
			  puts "Open：#{url}"
			  html = open(url, headers).read  
			rescue StandardError,Timeout::Error, SystemCallError, Errno::ECONNREFUSED #有些异常不是标准异常  
			  puts $!  
			  retries -= 1  
			  if retries > 0  
				sleep sleep_time and retry  
			  else  
				@logger.error($!)
			  end  
			end
		end	# end of safe_open

		def fetch(website)
			
			url = URI.parse(URI.encode(website))
			headers = {"User-Agent" => @user_agent}
			html_stream = safe_open(url , retries = 3, sleep_time = 0.2, headers)	
		
		end
	end # end class Crawler
	
	def create_file_to_write(name)
		file_path = File.join('.', "#{name}-#{Time.now.to_formatted_s(:number) }.txt")
		@file_to_write = IoFactory.init(file_path)
	end	
	def initialize(websites, name)
		@websites = websites
		@user_agent = name
		create_file_to_write("autozone")
	end
	
	#处理采集的参数
	def process
		start_time = Time.now
		website = @websites
		
		years = get_years(website)
		makers = get_makers(years)
		models = get_models(makers)
		engines = get_engines(models)
		
		engines.each do |engine, engine_url, model, maker, year|
			Car.create!(:year => year, :maker => maker, :model => model, :engine => engine, :tip => "autozone", :ymme => engine_url)
		end
		

	end #end process
	
	def get_years(url)
		result = Crawler.new(@user_agent).fetch(url)
		@year_doc = Nokogiri::HTML(result)
		#years
		#获取年份地址URL
		years_xpath = %q[//ul[@id = 'yearList']/li/ul/li/a]
		years = []
		@year_doc.xpath(years_xpath).each do |item|
			year_url = "http://www.autozone.com#{item.at_xpath('@href').to_s}"
			year = item.at_xpath('text()').to_s
			years << [year , year_url]
		end
		years
	end
	
	def get_makers(years)
		#makers
		#获取makers from years
		makers = []
		years.each do |year , url|
			puts year
			result = Crawler.new(@user_agent, "autozone").fetch(url)
			@makers_doc = Nokogiri::HTML(result)
			makers_xpath = %q[//ul/li/a]
			@makers_doc.xpath(makers_xpath).each do |item|
				maker_url = "http://www.autozone.com#{item.at_xpath('@href').to_s}"
				maker = item.at_xpath('text()').to_s
				makers << [maker, maker_url , year]
			end
			#break
		end	
		
		makers
	end	 #end get_maker
	
	def get_models(makers)
		#models
		#获取models from makers
		models = []
		makers.each do |maker, url ,year|
			puts maker
			result = Crawler.new(@user_agent, "autozone").fetch(url)
			@models_doc = Nokogiri::HTML(result)
			models_xpath = %q[//ul/li/a]
			@models_doc.xpath(models_xpath).each do |item|
				model_url = "http://www.autozone.com#{item.at_xpath('@href').to_s}"
				model = item.at_xpath('text()').to_s
				models << [model , model_url, maker, year]				
			end
			#break

		end
		models
	end
	
	def get_engines(models)
		engines = []
		models.each do |model , url, maker, year|
			puts "#{model} - #{maker} - #{year} "
			
			result = Crawler.new(@user_agent, "autozone").fetch(url)
			@engines_doc = Nokogiri::HTML(result)
			engines_xpath = %q[//ul/li/a]
			@engines_doc.xpath(engines_xpath).each do |item|
				engine_url = "http://www.autozone.com#{item.at_xpath('@href').to_s}"
				engine = item.at_xpath('text()').to_s
				engines << [engine, engine_url, model, maker, year]				
			end
			#break			
		end
		engines
	end
	
end

websites = "http://www.autozone.com/autozone/ymme/selector.jsp"

user_agent = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:13.0) Gecko/20100101 Firefox/13.0'
MultipleCrawler.new(websites, user_agent).process
