require 'thor'
require 'thor/group'
require 'artoo/generators/adaptor'

module Artoo
  module Commands
    class Generate < Thor
      register Artoo::Generator::Adaptor, 'adaptor', 'adaptor [NAME]', 'Generates a new adaptor'
    end
  end
end
