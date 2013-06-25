require 'thor'
require 'thor/group'
require 'artoo/generators/adaptor'

module Artoo
  module Generator
    class Main < Thor
      register Artoo::Generator::Adaptor, 'adaptor', 'adaptor [NAME]', 'Generates a new adaptor'
    end
  end
end
