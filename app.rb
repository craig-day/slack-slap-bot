require 'sinatra'
require 'json'

USER_MATCH = /(@\w+)/.freeze

ITEMS = {
  # fish
  'a trout' => 1.0,
  'a large trout' => 0.5,
  'a halibut' => 0.5,

  # slabs of meat
  'a 32oz porterhouse' => 0.25,
  'a slab of bacon' => 0.25,

  # construction items
  'a 2x4' => 0.25,
  'a crowbar' => 0.25,
  'a shovel' => 0.25
}.freeze

post '/' do
  halt(401, 'Invalid SLACK_TOKEN') unless valid_token?

  response.headers['Content-Type'] = 'application/json'

  JSON.dump({
    response_type: "in_channel",
    text: message
  })
end


def valid_token?
  ENV.fetch('SLACK_TOKEN') == params['token']
end

def message
  [ slap_source,
    slaps,
    slap_recipient,
    slap_modifier
  ].join(' ')
end

def slap_source
  "<@#{params['user_id']}|#{params['user_name']}>"
end

def slaps
  "slaps"
end

def slap_modifier
  "around a bit with #{weighted_rand(ITEMS)}"
end

def slap_recipient
  if params['text'].to_s.start_with?('@')
    "<#{params['text']}>"
  else
    params['text']
  end
end

def weighted_rand(items = {})
  range = items.values.inject(&:+)
  lucky = range * rand
  items.each{|k,v| lucky -= v; return k if lucky <= 0 }
end
