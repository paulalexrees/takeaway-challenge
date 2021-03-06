require 'rubygems'
require 'sinatra'
require 'twilio-ruby'
require_relative 'sms_message'

get '/sms' do
  incoming = params[:Body]
  begin order = eval(incoming)
    if order.empty?
      response = "Your order contained no items."
    else
      response = format_order(order)
    end
  rescue Exception => exc
    response = "Please submit a valid order."
  end

  twiml = Twilio::TwiML::Response.new do |r|
    r.Message response
  end
  twiml.text
end

def format_order(order)
  message = "Thank you for your order of:\n"
  order.each{|k,v| message << "#{v} x #{k}\n"}
  message << delivery_time
  message
end

def delivery_time
  "It will be delivered by #{Time.new.hour + 1}:#{Time.new.min}."
end
