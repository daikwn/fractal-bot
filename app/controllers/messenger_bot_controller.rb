require 'yahoo_parse_api'

class MessengerBotController < ActionController::Base
    
  def message(event, sender)
    YahooParseApi::Config.app_id = 'dj0zaiZpPXZhTWlrcHFVME9xOCZzPWNvbnN1bWVyc2VjcmV0Jng9Y2Y-'
    parse_api = YahooParseApi::Parse.new
    # GET Request
    profile = sender.get_profile[:body]
    profile_last_name = profile['last_name']
    profile_first_name = profile['first_name']
    result = parse_api.parse(event['message']['text'], {
             results: 'ma,uniq',
             uniq_filter: '9|10'})
    bot_rep = result['ResultSet']["ma_result"]['total_count']
             
    # profile = sender.get_profile(field) # default field [:locale, :timezone, :gender, :first_name, :last_name, :profile_pic]
    sender.reply({ text: "Reply: #{bot_rep}" })
    sender.reply({ text: "#{profile_last_name} #{profile_first_name}さんこんにちは" })
  end

  def delivery(event, sender)
  end

  def postback(event, sender)
    payload = event["postback"]["payload"]
    case payload
    when :something
      #ex) process sender.reply({text: "button click event!"})
    end
  end
end