#Given(/^a default list of server names$/) do
#  @loader=Roboparser::Loader.new
#  @list_servers=@loader.list_servers
#end

Given(/^a server "(.*?)" with "(.*?)"$/) do |arg1, arg2|
  loader=Loader.new
  loader.host_name=arg1
  loader.host_url=arg2

end