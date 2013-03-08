require 'nokogiri'
require 'open-uri'

require_relative 'file_io'
require_relative 'autozone_partno'
require_relative 'urls_list'

class Fetch
  def initialize(part_num, item_url = "")
   @part_num = part_num   
   @item_url = item_url
  end


  def search_url
    "http://www.autozone.com/autozone/catalog/search/searchResults.jsp?searchText=#{@part_num}&x=0&y=0"
  end

  def product_url
	
    @doc =  Nokogiri::HTML(open(search_url).read)
    relative_url = @doc.at_css('div.list a').attr("href")
  "http://www.autozone.com#{relative_url}"
  end

  def product_urls
    create_file_io_write("txt_test")
    @doc =  Nokogiri::HTML(open(search_url).read)
    result_arr = []
    @doc.css('div.list a').each do |item|
      regEx = /Brake/
      regEx1 = /Brake-Drum/
      regEx2 = /Brake-Rotor/
      txt_href = item.attr("href")
      #if regEx =~ item.text.strip()
      if regEx1 =~ txt_href || regEx2 =~ txt_href
	href = item.attr("href")
	result_arr << "http://www.autozone.com#{href}"
      end
    end
    @file_to_write.puts result_arr

    result_arr
  end
  def product_items
   create_file_io_write("txt_items")
   item_arr = []
    @item_doc = Nokogiri::HTML(open(@item_url).read)
    @item_doc.css("div.part-header > h3 > a").each do |item|
      href = item.attr("href")
      item_arr << "http://www.autozone.com#{href}"
    end
    @file_to_write.puts item_arr

    item_arr
  end


  private
  def create_file_io_write(name)
    file_path = File.join('.', "#{name}-#{Time.now.to_i}.txt")
    @file_to_write = IoFactory.init(file_path)
  end
end

=begin
#Dig the products' items list url
@part_nos.each_with_index do |part, i|
  puts "#{i}/#{@part_nos.length - 1}"
  Fetch.new(part).product_urls
end

#Dig the last items'url for applications
puts @urls.length
@urls.each_with_index do |url, i|
		next if i < 799 
  puts "#{i}/#{@urls.length - 1}"
  Fetch.new("", url).product_items
end
=end


