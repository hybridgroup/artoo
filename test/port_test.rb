require File.expand_path(File.dirname(__FILE__) + "/test_helper")

describe Artoo::Port do
  before do
    @remote_tcp_port = Artoo::Port.new("192.168.0.1:8080")
    @local_tcp_port = Artoo::Port.new("5678")
    @serial_port = Artoo::Port.new("/dev/tty.usb12345")
  end

  it 'Artoo::Port#port' do
    @remote_tcp_port.port.must_equal "8080"
    @local_tcp_port.port.must_equal "5678"
    @serial_port.port.must_equal "/dev/tty.usb12345"
  end

  it 'Artoo::Port#is_tcp?' do
    @remote_tcp_port.is_tcp?.must_equal true
    @local_tcp_port.is_tcp?.must_equal true
    @serial_port.is_tcp?.must_equal false
  end

  it 'Artoo::Port#is_serial?' do
    @remote_tcp_port.is_serial?.must_equal false
    @local_tcp_port.is_serial?.must_equal false
    @serial_port.is_serial?.must_equal true
  end

  it 'Artoo::Port#to_s' do
    @remote_tcp_port.to_s.must_equal "192.168.0.1:8080"
    @local_tcp_port.to_s.must_equal "localhost:5678"
    @serial_port.to_s.must_equal "/dev/tty.usb12345"
  end
end