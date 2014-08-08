require File.expand_path(File.dirname(__FILE__) + "/../test_helper")
require File.expand_path(File.dirname(__FILE__) + "/../../lib/artoo/api/api")

describe "API" do
  Server = Artoo::Api::Server

  describe "routes" do
    routes = [
      ["GET",  "/api"],
      ["GET",  "/api/commands"],
      ["POST", "/api/commands/command"],
      ["GET",  "/api/robots"],
      ["GET",  "/api/robots/TestBot"],
      ["GET",  "/api/robots/TestBot/commands"],
      ["POST", "/api/robots/TestBot/commands/cmd"],
      ["GET",  "/api/robots/TestBot/devices"],
      ["GET",  "/api/robots/TestBot/devices/ping"],
      ["GET",  "/api/robots/TestBot/devices/ping/commands"],
      ["POST", "/api/robots/TestBot/devices/ping/commands/ping"],
      ["GET",  "/api/robots/TestBot/connections"],
      ["GET",  "/api/robots/TestBot/connections/loopback"]
    ]

    it "should have a hash of routes" do
      Server.routes.class.must_equal Hash
    end

    routes.each do |method, uri|
      it "should resolve a #{method} request to #{uri}" do
        Server.routes[method].any? do |route|
          route.first =~ uri
        end.must_equal true
      end
    end
  end
end
