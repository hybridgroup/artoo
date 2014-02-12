require 'thor'
require 'thor/group'
require 'etc'

module Artoo
  module Commands
    class Commands < Thor
      include Thor::Actions
      include Artoo::Utility

      def self.banner(command, namespace = nil, subcommand = false)
        "#{basename} #{@package_name} #{command.usage}"
      end

      def self.install_dir
        "#{ install_path }/.artoo/commands"
      end

      def self.install_path
        ENV["GEM_HOME"] || ENV["RBENV_ROOT"] || Dir.home(Etc.getlogin)
      end
    end
  end
end
