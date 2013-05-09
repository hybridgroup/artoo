require 'artoo/utility'

module Artoo
  # The Connection class represents the interface to 
  # a specific group of hardware devices. Examples would be an
  # Arduino, a Sphero, or an ARDrone.
  class Connection
    include Celluloid
    include Artoo::Utility
    include Comparable

    attr_reader :parent, :name, :port, :adaptor, :connection_id

    def initialize(params={})
      @connection_id = rand(10000)
      @name = params[:name].to_s
      @port = Port.new(params[:port])
      @parent = params[:parent]

      require_adaptor(params[:adaptor] || :loopback)
    end

    def connect
      Logger.info "Connecting to '#{name}' on port '#{port}'..."
      adaptor.connect
    rescue Exception => e
      Logger.error e.message
      Logger.error e.backtrace.inspect
    end

    def disconnect
      Logger.info "Disconnecting from '#{name}' on port '#{port}'..."
      adaptor.disconnect
    end

    def connected?
      adaptor.connected?
    end

    def adaptor_name
      adaptor.class.name
    end

    def to_hash
      {:name => name,
       :connection_id => connection_id,
       :port => port.to_s,
       :adaptor => adaptor_name.to_s.gsub(/^.*::/, ''),
       :connected => connected?
      }
    end

    def as_json
      MultiJson.dump(to_hash)
    end

    def inspect
      "#<Connection @id=#{object_id}, @name='#{name}', @adaptor=#{adaptor_name}>"
    end

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

    private

    def require_adaptor(type)
      require "artoo/adaptors/#{type.to_s}"
      @adaptor = constantize("Artoo::Adaptors::#{classify(type.to_s)}").new(:port => port, :parent => current_instance)
    end
  end
end
