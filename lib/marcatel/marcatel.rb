# frozen_string_literal: true

# Marcatel
module Marcatel
  include RegexComparable
  # +Marcatel+ SOAP Client class
  class Client
    # Marcatel endpoints
    module Endpoint
      WSDL = [
        'http://b2c.marcatel.com.mx/MarcatelSMSWCF',
        '/ServicioInsertarSMS.svc?wsdl'
      ].join('')

      # Returns Marcatel::Client initialized with credentials from environment
      # @param [String] key
      # @return String
      def self.tns_key(key)
        "tns:#{key}"
      end

      # Returns phones with valid format for marcatel, only with 10 digits
      # @return String
      def self.valid_phones(phones)
        phones.map do |phone|
          valid_phone = RegexComparable::MARCATEL_VALID_PHONE.match(phone)
          valid_phone[1] if valid_phone.present?
        end
      end
    end

    # Marcatel SOAP operations
    module Operation
      INSERT_MESSAGE = :inserta_mensajes_xl
    end

    # Marcatel SOAP namespaces
    module Namespace
      INSERT_MESSAGE = 'InsertaMensajes_xl'
    end

    # Marcatel keys
    MARCATEL_LADA = ENV.fetch('MARCATEL_LADA') { '52' }

    # attributes
    attr_accessor :api_user, :api_password

    # delegates
    # Returns all available operations from the definition service
    # @return [Array[symbol]] - Operation names
    delegate :operations, to: :client

    # inializes a new +Marcatel::Client+ instance with the given arguments.
    # @return Marcatel::Client
    def initialize(args = {})
      args.each { |key, val| send "#{key}=", val }
    end

    # execute InsertaMensajes_xl function to send large sns to phones using
    #   Marcatel WSDL
    # @param [Hash] phones - phones number to send message
    # @param [String] message - sns message
    # @raise Marcatel::MarcatelError
    # @return Savon::Response
    def insert_message!(phones, message)
      params = {
        Mensaje: message,
        CadenaTelefonos: Endpoint.valid_phones(phones),
        Usuario: api_user,
        Password: api_password,
        Lada: MARCATEL_LADA,
        DobleVia: 0,
        MMensaje: 0,
        'Campaña' => 0,
        Prioridad: 1,
        Auxiliar: 0,
        Auxiliar2: 0,
        Origen: 0
      }
      # add tns prefix to all keys in guide
      params = params.deep_transform_keys { |key| Endpoint.tns_key(key) }
      response = execute_operation! Operation::INSERT_MESSAGE,
                                    Namespace::INSERT_MESSAGE,
                                    params
      response.body[:predocumentacion_response]
    end

    # loads and returns the WSDL operations described in Endpoint::WSDL
    # @return Savon::Client - Savon Client instance
    def client
      @client ||= Savon.client(
        wsdl: Endpoint::WSDL,
        no_message_tag: true,
        env_namespace: :soapenv,
        element_form_default: :unqualified
      )
    end

    private

    # executes an HTTP request via +Savon::Operation+ call method for the
    # given +request_args+
    # returns the JSON response as a ruby Hash.
    # @param request_args [Hash] - RestClient::Request args
    # @raise Marcatel::MarcatelError
    # @return Hash - Marcatel HTTP response
    # @private
    def execute_operation!(operation, namespace, request_args = {})
      args = { "tns:#{namespace}" => request_args }
      response = nil
      begin
        response = client.call operation, message: args
        result = response.http.code
        if result != 200
          error = MarcatelError.new(soap_exception: response,
                                    operation: operation,
                                    request_args: request_args)
          raise error
        end
      rescue Savon::SOAPFault => e
        error = MarcatelError.new(
          soap_exception: e,
          operation: operation,
          request_args: request_args
        )
        raise error
      end
      response
    end
  end

  # Exception Handing class for Marcatel HTTP Errors.
  # Encapsulates Savon::SOAPFault to be handled by the application.
  class MarcatelError < RuntimeError
    attr_accessor :request_args, :http_response, :http_code, :operation

    # inializes a new +Marcatel::Error+ instance with the given arguments.
    # @param soap_exception [Savon::SOAPFault] - original exception
    # @param operation [Symbol] - original operation
    # @param request_args [Hash] - original HTTP Request arguments
    # @return MarcatelError
    def initialize(soap_exception: nil, operation: nil, request_args: nil)
      self.request_args = request_args
      if soap_exception.present?
        self.operation = operation
        self.http_code = soap_exception.http.code
        self.http_response = soap_exception.to_hash
      else
        self.http_response = http_response
      end
    end
  end
end
