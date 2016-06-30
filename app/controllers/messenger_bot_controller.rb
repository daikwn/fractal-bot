class MessengerBotController < ActionController::Base
require 'yahoo_parse_api'
  
def message(event, sender)
  profile = sender.get_profile[:body]
  profile_last_name = profile['last_name']
  profile_first_name = profile['first_name'] 
  text = event['message']['text']
  
  if text == "起動" 
    @key = 0
    sender.reply({ "attachment":{
                   "type":"template",
                   "payload":{"template_type":"button",
                              "text":"川端康成による美しい日本語判定BOTへようこそ！",
                              "buttons":[
                             {
                              "type":"postback",
                              "title":"やってみる",
                              "payload":"OVER"
                             },
                             {
                              "type":"postback",
                              "title":"興味ない",
                              "payload":"UNDER"
                             }
                                        ]
                             }
                                }
  })
  elsif text != "起動" && @key != 1
    sender.reply({text: "【起動】で起動します。"})
  elsif text != "起動" && @key == 1
    YahooParseApi::Config.app_id = 'dj0zaiZpPXZhTWlrcHFVME9xOCZzPWNvbnN1bWVyc2VjcmV0Jng9Y2Y-'
    parse_api = YahooParseApi::Parse.new
    result = parse_api.parse(text, {
             results: 'ma,uniq',
             uniq_filter: '1|2'})
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
    hukushi = bot_rep.select do |b|
      b["pos"] == "副詞"
    end
    keiyoushi = bot_rep.select do |b|
      b["pos"] == "形容詞"
    end

    rep_m = meishi.count
    rep_d = doushi.count
    rep_j = joshi.count
    rep_jd = jodoushi.count
    rep_hk = hukushi.count
    rep_ky = keiyoushi.count
    
    usercountTO = rep_m + rep_d + rep_j + rep_jd + rep_hk + rep_ky
    userSL_m = (0.3229 - rep_m/usercountTO.to_f).abs
    userSL_d = (0.1189 - rep_d/usercountTO.to_f).abs
    userSL_j = (0.4164 - rep_j/usercountTO.to_f).abs
    userSL_jd = (0.1416 - rep_jd/usercountTO.to_f).abs
    userSL_hk = (0.0226 - rep_hk/usercountTO.to_f).abs
    userSL_ky = (0.0283 - rep_ky/usercountTO.to_f).abs
    userslTO = userSL_m + userSL_d + userSL_j + userSL_jd + userSL_hk + userSL_ky
    
    score = 100*(1-userslTO.to_f)
    
    sender.reply({ text: "名詞の数: #{rep_m}" })
    sender.reply({ text: "動詞の数: #{rep_d}" })
    sender.reply({ text: "助詞の数: #{rep_j}" })
    sender.reply({ text: "助動詞の数: #{rep_jd}" })
    sender.reply({ text: "副詞の数: #{rep_hk}" })
    sender.reply({ text: "形容詞の数: #{rep_ky}" })
    
    @key = 0
    
     if score >0
      sender.reply({ text: "#{profile_last_name} #{profile_first_name}さんの得点: #{score.ceil}" })
     elsif score <= 0
      sender.reply({text: "0点です。"})
     end
  
  end
end
  
  def delivery(event, sender)
  end
  
  def postback(event, sender)
    payload = event["postback"]["payload"]
    case payload
    when "OVER"
      @key = 1
      sender.reply({ text: "一文か二文程度で文章を記入してください。" })
    when "UNDER"
      sender.reply({ text: "そっすか…" })
    end
  end
end