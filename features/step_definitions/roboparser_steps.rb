# coding: utf-8
#Given(/^a default list of server names$/) do
#  @loader=Roboparser::Loader.new
#  @list_servers=@loader.list_servers
#end


Given(/^a server "(.*?)" with "(.*?)"$/) do |arg1, arg2|
  @host=Roboparser::Host.new(name:arg1,url:arg2)
end

When(/^I try to visit to the server$/) do
  @loader=Roboparser::Loader.new
  @loader.visit(@host)
end