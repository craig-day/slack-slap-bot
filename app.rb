require 'sinatra'
require 'json'

USER_MATCH = /(@\w+)/.freeze

post '/' do
  return 500 unless valid_token?

  JSON.dump({
    response_type: "in_channel",
    text: "@#{params['user_name']} slaps #{params['text']} around with a large trout"
  })
end


def valid_token?
  params['token'] == ENV['SLACK_TOKEN']
end
