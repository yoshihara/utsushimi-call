require "sinatra/base"
require "sinatra/reloader"
require "open-uri"
require "pry"
require "slack-poster"
require "twilio-ruby"


class UtsushimiCall < Sinatra::Base
  register Sinatra::Reloader

  configure do
    set slack_hook_url: ENV["SLACK_HOOK_URL"].dup.freeze
    set record_seconds: 30
  end

  before do
    @poster = Slack::Poster.new(settings.slack_hook_url)
  end

  # for check
  get "/ping" do
    "pong"
  end

  get "/records/new" do
    @poster.send_message "#{params['From']}から着信中です"

    Twilio::TwiML::Response.new do |r|
      r.Say "こんにちは", language: "ja-jp"
      r.Say "トーン音の、あとに、おはなしください", language: "ja-jp"
      r.Say "#{settings.record_seconds}秒、録音できます", language: "ja-jp"

      r.Record maxLength: settings.record_seconds, action: "/records", method: "post"
    end.text
  end

  post "/records" do
    response = Twilio::TwiML::Response.new do |r|
      r.Say "録音しました", language: "ja-jp"
      r.Say "Goodbye."
    end.text

    @poster.send_message "#{params['From']}から電話がありました\n #{params['RecordingUrl']}"

    response
  end

  run! if app_file == $0
end
