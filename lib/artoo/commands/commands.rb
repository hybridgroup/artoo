require 'thor'
require 'thor/group'

module Artoo
  module Commands
    class Commands < Thor
      include Thor::Actions
      include Artoo::Utility

      def self.banner(command, namespace = nil, subcommand = false)
        "#{basename} #{@package_name} #{command.usage}"
      end
    end
  end
end
