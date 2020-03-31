# frozen_string_literal: true

# +Slackable+ module.
module Slackable
  extend ActiveSupport::Concern

  # +Priority+ module
  module Priority
    GREEN = '#00FF00'
    YELLOW = '#FFFF00'
    RED = '#FF0000'
    PURPLE = '#6D3996'
    GURUCOMM = '#EC3B7D'
    DATA = {
      0 => GREEN,
      1 => YELLOW,
      2 => RED
    }.freeze

    # get color by current count
    # @param count [Integer] - count
    # @return String hex color
    def self.color(count)
      case count
      when 0
        DATA[count]
      when 1
        DATA[count]
      else
        DATA[2]
      end
    end
  end

  included do
    # Slack field format
    # @return Hash - Slack Field format
    def field(title, value, short = false)
      { title: title, value: value, short: short }
    end

    # sends a callback message to the slack channel
    # @param message [String]
    # @return Hash - Slack HTTP response
    def post_to_slack(channel, contents)
      client = Slack::Web::Client.new
      params = { channel: "##{channel}" }
      client.chat_postMessage params.merge(contents)
    end
  end
end
