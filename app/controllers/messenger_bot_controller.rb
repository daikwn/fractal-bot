class MessengerBotController < ActionController::Base
    require 'yahoo_parse_api'
    @application_ID = "dj0zaiZpPXZhTWlrcHFVME9xOCZzPWNvbnN1bWVyc2VjcmV0Jng9Y2Y-"
    YahooParseApi::Config.app_id = @application_ID
    
  def message(event, sender)

    # GET Request
    profile = sender.get_profile[:body]
    profile_last_name = profile['last_name']
    profile_first_name = profile['first_name']
 
    # profile = sender.get_profile(field) # default field [:locale, :timezone, :gender, :first_name, :last_name, :profile_pic]

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