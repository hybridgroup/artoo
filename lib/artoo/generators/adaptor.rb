require 'thor'
require 'thor/group'

module Artoo
  module Generator
    class Adaptor < Thor::Group
      include Thor::Actions

      argument :adaptor_name

      def copy_adaptor_directory
        say "Creating #{adaptor_name} adaptor..."
        empty_directory adaptor_name
        directory "adaptor", adaptor_name, :recursive => true
        say "Done!"
      end
    end
  end
end
