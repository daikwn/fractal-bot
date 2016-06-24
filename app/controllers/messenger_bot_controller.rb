require 'yahoo_parse_api'

class MessengerBotController < ActionController::Base
    
  def message(event, sender)
    YahooParseApi::Config.app_id = 'dj0zaiZpPXZhTWlrcHFVME9xOCZzPWNvbnN1bWVyc2VjcmV0Jng9Y2Y-'
    parse_api = YahooParseApi::Parse.new
    
    profile = sender.get_profile[:body]
    profile_last_name = profile['last_name']
    profile_first_name = profile['first_name']
    result = parse_api.parse(event['message']['text'], {
             results: 'ma,uniq',
             uniq_filter: '9|10'})
    bot_rep = result['ResultSet']['ma_result']['word_list']['word']
    meishi = bot_rep.select do |b|
      b["pos"] == "名詞"
    end
    doushi = bot_rep.select do |b|
      b["pos"] == "動詞"
    end
    joshi = bot_rep.select do |b|
      b["pos"] == "助詞"
    end
    jodoushi = bot_rep.select do |b|
      b["pos"] == "助動詞"
    end
    spword = bot_rep.select do |b|
      b["pos"] == "特殊"
    end
    rep_m = meishi.count
    rep_d = doushi.count
    rep_j = joshi.count
    rep_jd = jodoushi.count
    rep_sp = spword.count
    
    system ('python fractal.py')
    
    # profile = sender.get_profile(field) # default field [:locale, :timezone, :gender, :first_name, :last_name, :profile_pic]
    sender.reply({ text: "名詞: #{rep_m}" })
    sender.reply({ text: "動詞: #{rep_d}" })
    sender.reply({ text: "助詞: #{rep_j}" })
    sender.reply({ text: "助動詞: #{rep_jd}" })
    sender.reply({ text: "特殊: #{rep_sp}" })
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