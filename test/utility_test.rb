require File.expand_path(File.dirname(__FILE__) + "/test_helper")
require File.expand_path(File.dirname(__FILE__) + "/utility_test_cases")

describe Artoo::Utility do
  include UtilityTestCases
  include Artoo::Utility

  describe "#random_string" do
    it "returns an 8-character String" do
      random_string.must_be_kind_of String
      random_string.size.must_equal 8
    end
  end

  describe "#classify" do
    it "converts a snake_case string to CamelCase" do
      classify("firmata").must_equal "Firmata"
      classify("ardrone_awesome").must_equal "ArdroneAwesome"

      CamelToUnderscore.each do |camel, underscore|
        classify(underscore).must_equal camel
      end
    end
  end

  describe "#underscore" do
    it "converts CamelCase strings to snake_case" do
      CamelToUnderscore.each do |camel, underscore|
        underscore(camel).must_equal underscore
      end

      underscore("HTMLTidy").must_equal "html_tidy"
      underscore("HTMLTidyGenerator").must_equal "html_tidy_generator"
    end
  end

  describe "#constantize" do
    it "converts strings to constants" do
      run_constantize_tests_on do |string|
        constantize(string)
      end
    end
  end
end
