require 'rack/codehighlighter'
require "coderay"

use Rack::Codehighlighter, :coderay, :markdown => true,
  :element => "pre>code", :pattern => /\A:::(\w+)\s*\n/

set :css_dir, 'stylesheets'
set :js_dir, 'javascripts'
set :images_dir, 'images'

configure :build do
end

helpers do
  def menu_item(path)
    properties = {:href => "/#{path}", :class => "item"}

    if current_page.path == path
      properties[:class] = "active item"
    end

    properties
  end
end
