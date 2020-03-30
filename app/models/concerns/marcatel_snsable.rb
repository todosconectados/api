# frozen_string_literal: true

# +MarcatelSnsable+ module.
module MarcatelSnsable
  extend ActiveSupport::Concern
  included do
    # Returns marcatel client initialized with credentials
    # from environment variables
    # @return Marcatel::Client
    def self.marcatel_client
      @marcatel_client ||= Marcatel::Client.new(
        api_user: ENV['MARCATEL_USER'],
        api_password: ENV['MARCATEL_PASSWORD']
      )
    end

    # Returns integra client initialized with credentials
    # from environment variables
    # @return Integra::Client
    def marcatel_client
      self.class.marcatel_client
    end

    # Sends a sms to the specified num+ using aws sns service
    # @param [string] phone_number -phone number endpoint , use the structure
    # country code +  phone number Eg. 524423678840
    # @param [string] message - body message
    # @return Aws::SNS::Types::PublishResponse for publish operation result
    def marcatel_send_sms!(phone_number, message)
      marcatel_client.insert_message! phone_number, message
    end
  end
end
