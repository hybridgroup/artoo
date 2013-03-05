module Artoo
  module Events
    # Subscribe to an event from a device
    def on(device, events={})
      events.each do |k, v|
        subscribe("#{safe_name}_#{device.name}_#{k}", create_proxy_method(k, v))
      end
    end

    # Create an anonymous subscription method so we can wrap the
    # subscription method fire into a valid method regardless
    # of where it is defined
    def create_proxy_method(k, v)
      proxy_method_name(k).tap do |name|
        self.class.send :define_method, name do |*args|
          case v
          when Symbol
            self.send v.to_sym, *args
          when Proc
            v.call(*args)
          end
        end
      end
    end

    # A simple loop to create a 'fake' anonymous method
    def proxy_method_name(k)
      begin
        meth = "#{k}_#{Random.rand(999)}"
      end while respond_to?(meth)
      meth
    end
  end
end
