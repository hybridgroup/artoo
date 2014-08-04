require 'artoo/utility'

module Artoo
  # The Connection class represents the interface to
  # a specific group of hardware devices. Examples would be an
  # Arduino, a Sphero, or an ARDrone.
  class Connection
    include Celluloid
    include Artoo::Utility
    include Comparable

    attr_reader :parent, :name, :port, :adaptor, :connection_id, :details

    # Create new connection
    # @param [Hash] params
    # @option params :id      [String]
    # @option params :name    [String]
    # @option params :parent  [String]
    # @option params :adaptor [String]
    # @option params :port    [Integer]
    def initialize(params={})
      @connection_id = params[:id] || rand(10000).to_s
      @name = params[:name].to_s
      @port = Port.new(params[:port])
      @parent = params[:parent]
      @details = remove_keys(params, :name, :parent, :id, :loopback)

      require_adaptor(params[:adaptor] || :loopback, params)
    end

    # Creates adaptor connection
    # @return [Boolean]
    def connect
      Logger.info "Connecting to '#{name}' on port '#{port}'..."
      adaptor.connect
    rescue Exception => e
      Logger.error e.message
      Logger.error e.backtrace.inspect
    end

    # Closes adaptor connection
    # @return [Boolean]
    def disconnect
      Logger.info "Disconnecting from '#{name}' on port '#{port}'..."
      adaptor.disconnect
    end

    # @return [Boolean] Connection status
    def connected?
      adaptor.connected?
    end

    # @return [String] Adaptor class name
    def adaptor_name
      adaptor.class.name
    end

    # @return [Hash] connection
    def to_hash
      {
        :name => name,
        :adaptor => adaptor_name.to_s.gsub(/^.*::/, ''),
        :details => @details
      }
    end

    # @return [JSON] connection
    def as_json
      MultiJson.dump(to_hash)
    end

    # @return [String] Formated connection
    def inspect
      "#<Connection @id=#{object_id}, @name='#{name}', @adaptor=#{adaptor_name}>"
    end

    # Redirects missing methods to adaptor,
    # attemps reconnection if adaptor not connected
    def method_missing(method_name, *arguments, &block)
      unless adaptor.connected?
        Logger.warn "Cannot call unconnected adaptor '#{name}', attempting to reconnect..."
        adaptor.reconnect
        return nil
      end
      adaptor.send(method_name, *arguments, &block)
    rescue Exception => e
      Logger.error e.message
      Logger.error e.backtrace.inspect
      return nil
    end

    def respond_to_missing?(method_name, include_private = false)
      # TODO: verify that the adaptor supprts the method we're calling
      true
    end

    private

    def require_adaptor(type, params)
      if Artoo::Robot.test?
        type = :test
      end

      require "artoo/adaptors/#{type.to_s}"
      @adaptor = constantize("Artoo::Adaptors::#{classify(type.to_s)}").new(:port => port, :parent => current_instance, :additional_params => params)
    end
  end
end
