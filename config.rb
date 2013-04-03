require 'rack/codehighlighter'
require "coderay"

use Rack::Codehighlighter, :coderay, :markdown => true,
  :element => "pre>code", :pattern => /\A:::(\w+)\s*\n/

set :css_dir, 'stylesheets'
set :js_dir, 'javascripts'
set :images_dir, 'images'

configure :build do
end
