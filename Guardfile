# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard 'sprockets', :destination => 'api/public/', :asset_paths => ['api/assets/javascripts'] do
  watch(%r{api(/assets/javascripts/(.+\.(js))).*})
end

guard 'compass', :configuration_file => 'api/assets/compass.rb', :project_path => 'api/assets' do
  watch(%r{api(/assets/stylesheets/(.+\.(scss)))})
end

guard 'livereload' do
  watch(%r{api(/public/(.+\.(css|js|html)))}) 
end

