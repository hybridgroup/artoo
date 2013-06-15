# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard 'sprockets', :destination => 'api/public/', :asset_paths => ['api/assets/javascripts'], :root_file => "core.js" do
  watch(%r{api(/assets/javascripts/(.+\.(js))).*})
end

guard 'compass', :configuration_file => 'api/assets/compass.rb', :project_path => 'api/assets' do
  watch(%r{api(/assets/stylesheets/(.+\.(scss)))})
end
