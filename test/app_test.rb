ENV['RACK_ENV'] = 'test'

require_relative '../app'
require 'minitest'
require 'minitest/autorun'
require 'minitest/mock'
require 'webmock/minitest'
require 'rack/test'
require 'byebug'

describe Sinatra::Application do
  include Rack::Test::Methods

  let(:app) { Sinatra::Application }

  describe "when no token is specified" do
    it "should complain" do
      ENV.delete("SLACK_TOKEN")
      assert_raises KeyError do
        post '/'
      end
    end
  end

  describe "when unauthorized" do
    before do
      ENV["SLACK_TOKEN"] = "SUPER_SECRET"
    end

    it "should return 404 on GET" do
      get '/'
      assert last_response.not_found?
    end

    it "should fail on POST" do
      post '/'
      assert last_response.unauthorized?
    end
  end

  describe "when authorized" do
    before do
      ENV["SLACK_TOKEN"] = "TOKEN"
    end

    let(:request_data) { {"rack.session" => {"authorized_domain" => "example.com"}} }

    it "gets the index page" do
      post '/', {"token" => "TOKEN"}
      assert last_response.ok?
      response = JSON(last_response.body)
      assert_equal "in_channel", response["response_type"]
      assert response["text"].start_with?("<@|>")
    end
  end
end

