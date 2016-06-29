class MessengerBotController < ActionController::Base
  
require 'yahoo_parse_api'
require 'cairo'

format = Cairo::FORMAT_ARGB32
width  = 380
height = 205

@surface = Cairo::ImageSurface.new(format, width, height)
@context = Cairo::Context.new(@surface)

# 背景
@context.set_source_rgb(0.1, 0.1, 0.5)
@context.rectangle(0, 0, width, height)
@context.fill

# 文字色（グラデーション）
pattern = Cairo::LinearPattern.new(0, 0, width, height)
pattern.add_color_stop(0.0, :aqua)
pattern.add_color_stop(1.0, :blue)
@context.set_source(pattern)

  def show_text(context, x, y, size, text)
    context.move_to(x, y)
    context.font_size = size
    context.show_text(text)
  end
  
  def message(event, sender)
    YahooParseApi::Config.app_id = 'dj0zaiZpPXZhTWlrcHFVME9xOCZzPWNvbnN1bWVyc2VjcmV0Jng9Y2Y-'
    parse_api = YahooParseApi::Parse.new
    profile = sender.get_profile[:body] # default field [locale, timezone, gender, first_name, last_name, profile_pic]
    text = event['message']['text']
    profile = sender.get_profile[:body]
    profile_last_name = profile['last_name']
    profile_first_name = profile['first_name']
    
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
    
    show_text(@context,  50, 100, 70, "score")
    @surface.write_to_png("./tmp/score.png")
    
    sender.reply({ text: "名詞: #{rep_m}" })
    sender.reply({ text: "動詞: #{rep_d}" })
    sender.reply({ text: "助詞: #{rep_j}" })
    sender.reply({ text: "助動詞: #{rep_jd}" })
    sender.reply({ text: "副詞: #{rep_hk}" })
    sender.reply({ text: "形容詞: #{rep_ky}" })
    sender.reply({ text: "あなたの得点: #{score.ceil}" })
    sender.reply({ text: "#{profile_last_name} #{profile_first_name}さんこんにちは" })
    sender.reply({ "attachment": {
                "type": "image",
                "payload": {
                "url": "./tmp/score.png"}
                            }
                })
    
    
  end
  def delivery(event, sender)
  end
  def postback(event, sender)
    payload = event["postback"]["payload"]
    case payload
    when :something
    end
  end
end