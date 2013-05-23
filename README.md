# artoo

http://artoo.io/

Artoo is a micro-framework for robotics using Ruby.

Artoo provides a simple, yet powerful domain-specific language (DSL) for robotics and physical computing.

[![Code Climate](https://codeclimate.com/github/hybridgroup/artoo.png)](https://codeclimate.com/github/hybridgroup/artoo) [![Build Status](https://travis-ci.org/hybridgroup/artoo.png?branch=master)](https://travis-ci.org/hybridgroup/artoo)

## Examples:

### Basic

#### Arduino with an LED and a button, using the Firmata protocol.

```ruby
require 'artoo'

connection :arduino, :adaptor => :firmata, :port => '/dev/tty.usbmodemxxxxx'
device :led, :driver => :led, :pin => 13
device :button, :driver => :button, :pin => 2

work do
  on button, :push => proc {led.toggle}
end
```

#### Parrot ARDrone 2.0

```ruby
require 'artoo'

connection :ardrone, :adaptor => :ardrone
device :drone, :driver => :ardrone
  
work do
  drone.start
  drone.take_off
  
  after(25.seconds) { drone.hover.land }
  after(30.seconds) { drone.stop }
end
```

### Modular

You can also write more modular class-oriented code, that allows you to control swarms of robots:

```ruby
require 'artoo/robot'

SPHEROS = ["4567", "4568", "4569", "4570", "4571"]

class SpheroRobot < Artoo::Robot
  connection :sphero, :adaptor => :sphero
  device :sphero, :driver => :sphero
  
  work do
    every(3.seconds) do
      sphero.roll 90, rand(360)
    end
  end
end

robots = []
SPHEROS.each {|p|
  robots << SpheroRobot.new(:connections => 
                              {:sphero => 
                                {:port => p}})
}

SpheroRobot.work!(robots)
```

Ruby versions supported: Ruby 2.0, Ruby 1.9.3, JRuby 1.7.4, and Rubinius 2.0-rc1


Artoo is conceptualy influenced by Sinatra (https://github.com/sinatra/sinatra) as well as borrowing some code from it.

Artoo provides a robust actor-based messaging architecture, that can support fully multi-threaded operation and high-concurrency, as long as it is supported by the Ruby version in which it is executing. This means you will need to use JRuby or Rubinius for maximum concurrency. 

To a large extent, this is due to being built on top of Celluloid (https://github.com/celluloid/celluloid), Celluloid::IO (https://github.com/celluloid/celluloid-io), and Reel (https://github.com/celluloid/reel).

## Hardware support:

Artoo has a extensible system for connecting to hardware devices. The following robotics and physical computing platforms are currently supported:

  - Arduino (http://www.arduino.cc/) adaptor (https://github.com/hybridgroup/artoo-arduino)
  - ARDrone (http://ardrone2.parrot.com/) adaptor (https://github.com/hybridgroup/artoo-ardrone)
  - Roomba (http://www.irobot.com/us/robots/Educators/Create.aspx) adaptor (https://github.com/hybridgroup/artoo-roomba)
  - Sphero (http://www.gosphero.com/) adaptor (https://github.com/hybridgroup/artoo-sphero)

More platforms are coming soon!

Do you have some hardware that is not yet supported by Artoo? We want to help you, help us, help them! Get in touch...

## API:

Artoo includes a RESTful API to query the status of any robot running within a group, including the connection and device status, and device streaming data via websockets.

To activate the API, use the `api` command like this:

```ruby
require 'artoo'

connection :loop
device :passthru
api :host => '127.0.0.1', :port => '4321'

work do
  puts "Hello from the API running at #{api_host}:#{api_port}..."
end
```

Once the robot or group is working, you can view the main API page at the host and port specified.

## Test-Driven Robotics:

Artoo makes it easy to do Test Driven Development (TDD) of your robotic devices using your favorite Ruby test and mocking frameworks.

Here is an example that uses Minitest and Mocha:

```ruby
describe 'sphero' do
  let(:robot) { Artoo::MainRobot.new }
   
  it 'has work to do every 3 seconds' do
    robot.work
     
    robot.has_work?(:every, 3.seconds).wont_be_nil
  end
   
  it 'must roll every 3 seconds' do
    robot.sphero.expects(:roll).twice
     
    robot.work
    sleep 6.1
  end
   
  it 'receives collision event' do
    robot.expects(:contact)
     
    robot.work
    robot.sphero.publish("collision", "clunk")
    sleep 0.1
  end
end
```
to describe the following Sphero robot:

```ruby
require 'artoo'

connection :sphero, :adaptor => :sphero, :port => '127.0.0.1:4560'
device :sphero, :driver => :sphero

def contact(*args)
  @contacts ||= 0
  @contacts += 1
  puts "Contact #{@contacts}"
end

work do
  on sphero, :collision => :contact

  every(3.seconds) do
    puts "Rolling..."
    sphero.roll 90, rand(360)
  end
end
```

## Console:

Artoo includes Robi, a console based on Pry (http://pryrepl.org/) to allow you to interactively debug and control your robot.

```
$ robi ./examples/hello.rb 
I, [2013-05-21T18:09:05.179630 #8752]  INFO -- : Registering connection 'loop'...
I, [2013-05-21T18:09:05.180681 #8752]  INFO -- : Preparing work...
robi> start
Starting main robot...
I, [2013-05-21T18:09:37.086550 #8752]  INFO -- : Initializing connection loop...
I, [2013-05-21T18:09:37.092231 #8752]  INFO -- : Starting work...
I, [2013-05-21T18:09:37.092691 #8752]  INFO -- : Connecting to 'loop' on port '#<Artoo::Port:0x104e4>'...
robi> hello
hello
robi> stop
Stopping robots...
robi> exit
D, [2013-05-21T18:09:53.507709 #8752] DEBUG -- : Terminating 7 actors...
D, [2013-05-21T18:09:53.508622 #8752] DEBUG -- : Shutdown completed cleanly
```

## Getting Started:

### Installation

```ruby
gem install artoo
```

Then install the gems required by the hardware you want to use. For example, if you wanted to integrate a Wiiclassic controller connected to an Arduino to fly your ARDrone:

```ruby
gem install artoo-arduino
gem install artoo-ardrone
```

If you will be using socket to serial commuication (required if you will use JRuby or Rubinius), you are ready to start programming your hardware. 

If you want to connect via serial port directly, and are using MRI, install the hybridgroup-serialport gem:

```ruby
gem install hybridgroup-serialport
```

### Writing your robot code:

Now you are ready to write your own code. Take a look at the examples directory for a whole bunch of code you can use to help get started. We recommend using TDR (Test-Driven Robotics) with your preferred test frameworks.

### Running your robot:

```ruby
ruby myrobot.rb
```

## Wiki

Check out our [wiki](https://github.com/hybridgroup/artoo/wiki) for more docs

(c) 2012-2013 The Hybrid Group
