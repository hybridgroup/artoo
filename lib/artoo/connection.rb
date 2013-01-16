require 'artoo/utility'

module Artoo
  # The Connection class represents the interface to 
  # a specific group of hardware devices. Examples would be an
  # Arduino, a Sphero, or an ARDrone.
  class Connection
    include Celluloid
    include Artoo::Utility

    attr_reader :parent, :name, :type, :port, :connector

    def initialize(params={})
      @name = params[:name].to_s
      @type = params[:type] || :loopback
      @port = params[:port]
      @parent = params[:parent]

      require_connector
    end

    def connect
      Logger.info "Connecting to '#{name}' on port '#{port}'..."
      connector.connect
    end

    def disconnect
      Logger.info "Disconnecting from '#{name}' on port '#{port}'..."
      connector.disconnect
    end

    def method_missing(method_name, *arguments, &block)
      connector.send(method_name, *arguments, &block)
    end

    private

    def require_connector
      require "artoo/connector/#{type.to_s}"
      @connector = constantize("Artoo::Connector::#{type.to_s.capitalize}").new(:port => port, :parent => Actor.current)
    end
  end
end