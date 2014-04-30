# coding: utf-8
require 'spec_helper'
module Roboparser
  describe Host do
    before(:each) do
      @host=Host.new(name:'Yandex',url:'http://yandex.ua/yandsearch?lr=142&text=привет')
    end
    context "#name" do
      it "name" do
        expect(@host.name) == "Yandex"
      end
    end
    context "#url" do
      it "url" do
        expect(@host.url) == 'http://yandex.ua/yandsearch?lr=142&text=привет'
      end
    end
    context "#uri" do
      it "uri to_s" do
        #expect(@host.uri).to be_a_instance_of(Addressable::URI)
        expect(@host.uri) == "http://yandex.ua/yandsearch?lr=142&text=%D0%BF%D1%80%D0%B8%D0%B2%D0%B5%D1%82"
      end
    end
  end
end


