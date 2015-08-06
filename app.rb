require "sinatra/base"
require "sinatra/reloader"
require "open-uri"
require "pry"
require "slack-poster"
require "twilio-ruby"

class UtsushimiCall < Sinatra::Base
  register Sinatra::Reloader

  SLACK_HOOK_URL = ENV["SLACK_HOOK_URL"].dup.freeze

  # get "/" do
  #   Twilio::TwiML::Response.new do |r|
  #     r.Gather numDigits: "1", action: "/records/new", method: "get" do |g|
  #       g.Say "いち、を、おしてください", language: "ja-jp"
  #     end
  #   end.text
  # end

  get "/records/new" do
    Twilio::TwiML::Response.new do |r|
      r.Say "こんにちは", language: "ja-jp"
      r.Say "トーン音の、あとに、おはなしください", language: "ja-jp"
      r.Record maxLength: "5", action: "/records", method: "post"
    end.text
  end

  post "/records" do
    response = Twilio::TwiML::Response.new do |r|
      r.Say "録音しました", language: "ja-jp"
      r.Say "Goodbye."
    end.text

    # File.open("voice-#{Time.now.strftime("%Y%m%d_%H%M%S_%N")}.wav", "wb") { |f| f.print(open(params['RecordingUrl']).read) }

    poster = Slack::Poster.new(SLACK_HOOK_URL)
    poster.send_message "#{params['From']}から電話がありました。\n #{params['RecordingUrl']}"

    response
  end

  run! if app_file == $0
end
