Given(/^a default list of server names$/) do
  @loader=Roboparser::Loader.new
  @list_servers=@loader.list_servers
end