class MessengerBotController < ActionController::Base
require 'yahoo_parse_api'
require 'bing-search'
BingAPIKEY = 'lYikK+t6tN1ecVMq/Td1G5KSN0NxEY7yDISQvfyOT7w'

@@key = 0

def message(event, sender)
  profile = sender.get_profile[:body]
  profile_last_name = profile['last_name']
  profile_first_name = profile['first_name'] 
  text = event['message']['text']
  if text == "起動" 
    @@key = 0
    sender.reply({ "attachment":{
                   "type":"template",
                   "payload":{"template_type":"button",
                              "text":"川端康成に学ぶ。美しい日本語判定BOTへようこそ！",
                              "buttons":[
                             {
                              "type":"postback",
                              "title":"やってみる。",
                              "payload":"OVER"
                             },
                             {
                              "type":"postback",
                              "title":"興味ない。",
                              "payload":"UNDER"
                             }
                                        ]
                             }
                                }
  })
  elsif text != "起動" && @@key != 1
    sender.reply({text: "【起動】で起動します。"})
    
  elsif text != "起動" && @@key == 1
    @@key = 0
    BingSearch.account_key = BingAPIKEY
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
    userSL_m = (0.297420334 - rep_m/usercountTO.to_f).abs
    userSL_d = (0.124430956 - rep_d/usercountTO.to_f).abs
    userSL_j = (0.379362671 - rep_j/usercountTO.to_f).abs
    userSL_jd = (0.145675266 - rep_jd/usercountTO.to_f).abs
    userSL_hk = (0.025796662 - rep_hk/usercountTO.to_f).abs
    userSL_ky = (0.027314112 - rep_ky/usercountTO.to_f).abs
    userslTO = userSL_m + userSL_d + userSL_j + userSL_jd + userSL_hk + userSL_ky
    
    score = 100*(1-userslTO.to_f)
    scoreSE = score.ceil
    scoreSER = scoreSE.to_s
    
    sender.reply({ text: "名詞の数: #{rep_m}" })
    sender.reply({ text: "動詞の数: #{rep_d}" })
    sender.reply({ text: "助詞の数: #{rep_j}" })
    sender.reply({ text: "助動詞の数: #{rep_jd}" })
    sender.reply({ text: "副詞の数: #{rep_hk}" })
    sender.reply({ text: "形容詞の数: #{rep_ky}" })
    
    if 0 < score
      sender.reply({ text: "#{profile_last_name} #{profile_first_name}さんの得点" })
      BingSearch.account_key = BingAPIKEY
      bing_image = BingSearch.image(scoreSER, limit: 30).shuffle[0]
      if bing_image.nil?
          sender.reply({ text: "画像が見つかりませんでした" })
      else
          sender.reply({ "attachment": {
                         "type": "image",
                         "payload": {"url": bing_image.media_url}
                                        }
                      })
      end
    else
      sender.reply({ text: "0点です。"})
    end

    if 0 < score && score <= 20
      sender.reply({ text: "★やる気あんのか"})
    elsif 20 < score && score <= 40
      sender.reply({ text: "★少し文章が短すぎるかもしれませんね。もう一文増やしてみればよいのでは？"})
    elsif 40 < score && score <= 60
      sender.reply({ text: "★うーん…表現に工夫を加えてみましょう。比喩表現を入れてみるとか？"})
    elsif 60 < score && score <= 80
      sender.reply({ text: "★なかなかハイスコアです。ちなみに川端康成の文章を判定すると平均85点くらいです。"})
    elsif 80 < score && score <= 100
      sender.reply({ text: "★ﾋﾞｭｰﾃｨﾌｫｰ"})
    elsif score <= 0
      sender.reply({ text: "文章になってません。"})
    end
  end
end
  
  def delivery(event, sender)
  end
  def postback(event, sender)
    payload = event["postback"]["payload"]
    case payload
    when "OVER"
      @@key = 1
      sender.reply({ text: "一文から二文程度で、判定したい文章を記入してください。" })
    when "UNDER"
      @@key = 0
      sender.reply({ text: "そっすか…" })
    end
  end
end