require 'pp'
require 'nokogiri'
require 'open-uri'

class Test
	def process
		@doc = ""
		title_command = "pp 'ok! let us  read baidu title .'"
		get_command = "@doc =  Nokogiri::HTML(open('http://www.baidu.com/').read)   ; puts @doc.at_css('title')"
		title_xpath = %q[//title]

		eval title_command
		eval get_command

		puts @doc.at_css('title')
		puts @doc.at_xpath(title_xpath)
	end
end

=begin
def sum(*num)
  result=0
  num.each{|item|result+=item}
  return result
end
=end

Test.new().process
