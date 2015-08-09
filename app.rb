require "sinatra/base"
require "sinatra/reloader"
require "open-uri"
require "pry"
require "slack-poster"
require "twilio-ruby"

unless SLACK_HOOK_URL
  SLACK_HOOK_URL = ENV["SLACK_HOOK_URL"].dup.freeze
  RECORD_SECONDS = 30
end

class UtsushimiCall < Sinatra::Base
  register Sinatra::Reloader

  before do
    @poster = Slack::Poster.new(SLACK_HOOK_URL)
  end

  get "/records/new" do
    Twilio::TwiML::Response.new do |r|
      r.Say "こんにちは", language: "ja-jp"
      r.Say "トーン音の、あとに、おはなしください", language: "ja-jp"
      r.Say "#{RECORD_SECONDS}秒、録音できます", language: "ja-jp"

      r.Record maxLength: RECORD_SECONDS, action: "/records", method: "post"
    end.text
  end

  post "/records" do
    response = Twilio::TwiML::Response.new do |r|
      r.Say "録音しました", language: "ja-jp"
      r.Say "Goodbye."
    end.text

    @poster.send_message "#{params['From']}から電話がありました。\n #{params['RecordingUrl']}"

    response
  end

  run! if app_file == $0
end
