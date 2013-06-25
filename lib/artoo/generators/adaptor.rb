require 'thor'
require 'thor/group'

module Artoo
  module Generator
    class Adaptor < Thor::Group
      def create_directory
        say "create_directory"
      end

      def create_gemfile
        say "create_gemfile"
      end

      def create_adaptor
        say "create_adaptor"
      end

      def create_driver
        say "create_driver"
      end
    end
  end
end
