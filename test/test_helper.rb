require 'minitest/autorun'
require 'mocha/setup'

require 'artoo/robot'

Celluloid.logger = nil

MiniTest::Spec.before do
  Celluloid.shutdown
  Celluloid.boot
end
