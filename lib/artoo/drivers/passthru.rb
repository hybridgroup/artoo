require 'artoo/drivers/driver'

module Artoo
  module Drivers
    # The Passthru driver just passes calls along to the parent's connection.
    class Passthru < Driver
    end
  end
end