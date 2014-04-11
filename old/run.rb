require 'fiber'
# require 'eventmachine'
require 'em-http-request'
def http_get(url)
  puts "1 step #{url}"
  f = Fiber.current
  http = EventMachine::HttpRequest.new(url).get
  puts "2 step #{url}"
  # resume fiber once http call is done
  http.callback { f.resume(http) }
  puts "3 step #{url}"
  http.errback  { f.resume(http) }
  puts "4 step #{url}"

  return Fiber.yield
end

EventMachine.run do
  Fiber.new{
    puts '5 step '
    page = http_get('https://www.google.com/')
    #puts page.methods
    #puts page.state
    #state=
    puts page.response
    #response=
    #    response_header
    #error
    #content_charset
    #req
    #cookies
    #reset!
    #last_effective_url
    #redirects
    #peer
    #connection_completed
    #on_request_complete
    #continue?
    #finished?
    #redirect?
    #unbind
    #on_error
    #close
    #stream
    #headers
    #normalize_body
    #build_request
    #send_request
    #on_body_data
    #on_decoded_body_data
    #parse_response_header
    #escape
    #unescape
    #bytesize
    #munge_header_keys
    #encode_host
    #encode_request
    #encode_query
    #encode_param
    #form_encode_body
    #encode_field
    #encode_auth
    #encode_headers
    #encode_cookie
    #callback
    #cancel_callback
    #errback
    #cancel_errback
    #set_deferred_status
    #timeout
    #cancel_timeout
    #succeed
    #set_deferred_success
    #fail
    #set_deferred_failure
    #nil?
    #===
    #    =~
    #    !~
    #    eql?
    #hash
    #<=>
    #    class
    #    singleton_class
    #      clone
    #      dup
    #      initialize_dup
    #      initialize_clone
    #      taint
    #      tainted?
    #      untaint
    #      untrust
    #      untrusted?
    #      trust
    #      freeze
    #      frozen?
    #      to_s
    #      inspect
    #      methods
    #      singleton_methods
    #      protected_methods
    #      private_methods
    #      public_methods
    #      instance_variables
    #      instance_variable_get
    #      instance_variable_set
    #      instance_variable_defined?
    #      instance_of?
    #      kind_of?
    #      is_a?
    #      tap
    #      send
    #      public_send
    #      respond_to?
    #      respond_to_missing?
    #      extend
    #      display
    #      method
    #      public_method
    #      define_singleton_method
    #      object_id
    #      to_enum
    #      enum_for
    #      ==
    #          equal?
    #      !
    #      !=
    #          instance_eval
    #      instance_exec
    #      __send__
    #      __id__
    puts '6 step '
    puts "Fetched page: #{page.response_header.status}"

    if page
      puts '7 step '
      page = http_get('https://www.google.com/search?q=eventmachine')
      puts page.response
      puts '8 step '
      puts "Fetched page 2: #{page.response_header.status}"
    end
  }.resume
end