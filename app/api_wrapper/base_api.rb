# frozen_string_literal: true

##
# This is an abstract class used as a base for all API wrapper classes.
#
# It includes {HTTParty gem}[https://github.com/jnunemaker/httparty]

class BaseApi
  include HTTParty

  ##
  # Class representing 500 HTTP response code (Internal Server Error) returned by API
  class Error500Exception < ApiException; end
  ##
  # Class representing 422 HTTP response code (Unprocessable Entity) returned by API
  class Error422Exception < ApiException; end
  ##
  # Class representing 404 HTTP response code (Not Found) returned by API
  class Error404Exception < ApiException; end
  ##
  # Class representing 400 HTTP response code (Bad Request) returned by API
  class Error400Exception < ApiException; end

  class << self
    ##
    # Performs a HTTP request and returns a hash with parsed body
    #
    # ==== Attributes
    #
    # * +method+ - string or symbol, a valid HTTP request verb eg. +:get+
    # * +path+ - string, a path of a request eg. +'/users'+
    # * +options+ - hash, options like headers, the request body, query params
    #
    # ==== Exceptions
    #
    # Exception are raised based on HTTP status of the response.
    # Other HTTP statuses than 400, 404, 422 and errors during response parsing are treated as 500.
    #
    # * {400 Exception}[rdoc-ref:BaseApi::Error400Exception]
    # * {404 Exception}[rdoc-ref:BaseApi::Error404Exception]
    # * {422 Exception}[rdoc-ref:BaseApi::Error422Exception]
    # * {500 Exception}[rdoc-ref:BaseApi::Error500Exception]
    def request(method, path, options = {})
      response_object = public_send(method, path, options).response
      parsed_body = validate_response(response_object.response)
      log_action 'The call was successful'
      parsed_body
    end

    private

    ##
    # Logs given message at +info+ level with a proper tag
    #
    # ==== Attributes
    #
    # * +msg+ - string, log message
    #
    def log_action(msg)
      Rails.logger.info "[#{name}] #{msg}"
    end

    ##
    # Logs given exception at +error+ level with a proper tag
    #
    # ==== Attributes
    #
    # * +exception+ - exception
    #
    def log_exception(exception)
      Rails.logger.error "[#{name}] #{exception.message}"
    end

    ##
    # validates an API response and parses its body from JSON.
    # Returns parsed JSON object to hash or
    # raises exception if status is above 400 or parsing fails.
    #
    def validate_response(response_struct)
      status = response_struct.code.to_i
      parsed_body = parse_body(response_struct.body)

      return parsed_body unless status.between?(400, 599)

      status_message = response_struct.msg
      exception = error_klass(status).new(status, status_message, parsed_body)
      log_exception(exception)
      raise exception
    end

    ##
    # Parses response body and returns a hash.
    # +JSON::ParserError+ is treated as 500.
    def parse_body(body)
      JSON.parse(body.presence || '{}')
    rescue JSON::ParserError
      exception = Error500Exception.new(500, 'Response body parsing failed', body)
      log_exception(exception)
      raise exception
    end

    ##
    # Matches error status with a proper exception class.
    # Returns an error class.
    def error_klass(status)
      case status
      when 400
        Error400Exception
      when 404
        Error404Exception
      when 422
        Error422Exception
      else
        Error500Exception
      end
    end
  end
end
