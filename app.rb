require 'sinatra'
require 'json'

USER_MATCH = /(@\w+)/.freeze

ITEMS = [
  # fish
  'a large trout',
  'a trout',
  'a halibut',

  # slabs of meat
  'a 32oz porterhouse',
  'a slab of bacon',

  # construction items
  'a 2x4',
  'a crowbar',
  'a shovel'
].freeze

post '/' do
  return 400 unless valid_token?

  response.headers['Content-Type'] = 'application/json'

  message = [
    "<@#{params['user_id']}|#{params['user_name']}",
    'slaps',
    params['text'],
    'around a bit with',
    random_item
  ].join(' ')

  JSON.dump({
    response_type: "in_channel",
    text: message
  })
end


def valid_token?
  params['token'] == ENV['SLACK_TOKEN']
end

def random_item
  ITEMS.sample
end
