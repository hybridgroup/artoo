require File.expand_path(File.dirname(__FILE__) + "/test_helper")
require File.expand_path(File.dirname(__FILE__) + "/../lib/artoo/api")

class ExampleRequest
  extend Forwardable
  def_delegators :@headers, :[], :[]=
  attr_accessor  :method, :path, :version, :body

  def initialize(method = :get, path = "/", version = "1.1", headers = {}, body = nil)
    @method = method.to_s.upcase
    @path = path
    @version = "1.1"
    @headers = {
      'Host'       => 'www.example.com',
      'Connection' => 'keep-alive',
      'User-Agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_3) AppleWebKit/535.11 (KHTML, like Gecko) Chrome/17.0.963.78 S',
      'Accept'     => 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
      'Accept-Encoding' => 'gzip,deflate,sdch',
      'Accept-Language' => 'en-US,en;q=0.8',
      'Accept-Charset'  => 'ISO-8859-1,utf-8;q=0.7,*;q=0.3'
    }.merge(headers)

    @body = nil
  end

  def to_s
    if @body && !@headers['Content-Length']
      @headers['Content-Length'] = @body.length
    end

    "#{@method} #{@path} HTTP/#{@version}\r\n" <<
    @headers.map { |k, v| "#{k}: #{v}" }.join("\r\n") << "\r\n\r\n" <<
    (@body ? @body : '')
  end
end

describe Artoo::Api do
	describe Artoo::ApiRouteHelpers do

		class DummyClass
			include Artoo::ApiRouteHelpers
		end

		it "should have a list of routes" do
			DummyClass.routes.class.must_equal Hash
		end

		it "should be able to define methods" do
			DummyClass.instance_eval <<-EOE
				get '/' do
				end

        get_ws '/sock' do
        end
			EOE

			DummyClass.routes['GET'].length.must_equal 2
		end
	end

end
