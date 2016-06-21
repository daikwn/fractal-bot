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
    bot_rep = result['ResultSet']['ma_result']['word_list']['word']
    rep_s = bot_rep.count("名詞")
    rep_v = bot_rep.count("動詞")
    rep_c = bot_rep.count("助詞")
    rep_cv = bot_rep.count("助動詞")
    rep_sp = bot_rep.count("特殊")
             
    # profile = sender.get_profile(field) # default field [:locale, :timezone, :gender, :first_name, :last_name, :profile_pic]
    sender.reply({ text: "Reply: #{rep_s}" })
    sender.reply({ text: "Reply: #{rep_v}" })
    sender.reply({ text: "Reply: #{rep_c}" })
    sender.reply({ text: "Reply: #{rep_cv}" })
    sender.reply({ text: "Reply: #{rep_sp}" })
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