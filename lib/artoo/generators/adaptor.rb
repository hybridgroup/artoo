require 'thor'
require 'thor/group'
require 'artoo/version'

module Artoo
  module Generator
    class Adaptor < Thor::Group
      include Thor::Actions
      include Artoo::Utility

      argument :adaptor_name

      def self.source_root
        File.dirname(__FILE__)
      end

      def adaptor_class_name
        classify(adaptor_name)
      end

      def artoo_version
        Artoo::VERSION
      end

      def artoo_adaptor_name
        "artoo-#{adaptor_name}"
      end

      def copy_adaptor_directory
        say "Creating #{artoo_adaptor_name} adaptor..."
        empty_directory artoo_adaptor_name
        directory "adaptor", artoo_adaptor_name, :recursive => true
        say "Done!"
      end
    end
  end
end
