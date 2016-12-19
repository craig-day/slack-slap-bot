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
    slap_source,
    'slaps',
    slap_recipient,
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

def slap_source
  "<@#{params['user_id']}|#{params['user_name']}>"
end

def slap_recipient
  if params['text'].start_with?('@')
    "<#{params['text']}>"
  else
    params['text']
  end
end

def random_item
  ITEMS.sample
end
