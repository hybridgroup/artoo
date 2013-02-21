# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard 'sprockets', :destination => 'api/public/', :asset_paths => ['api/assets/javascripts', 'api/assets/stylesheets'] do
  watch(%r{api(/assets/\w+/(.+\.(css|js))).*})
end

guard 'livereload' do
  watch(%r{api(/public/(.+\.(css|js|html)))}) 
end
