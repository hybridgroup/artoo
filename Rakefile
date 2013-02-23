require 'sass'

task :default => :compile

desc "Compile SASS into CSS"
task :compile do
  `sass --update --style compressed ./css/sass/style.scss:css/style.css`
end

desc "Watch the sass folder"
task :watch do
  `sass --watch --style compressed ./css/sass/style.scss:css/style.css`
end
