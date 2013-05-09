module Ace
  module Base
    class Case
      class Dice
      end
    end
    class Fase < Case
    end
  end
  class Gas
    include Base
  end
end

class Object
  module AddtlGlobalConstants
    class Case
      class Dice
      end
    end
  end
  include AddtlGlobalConstants
end

module UtilityTestCases
  def run_constantize_tests_on
    assert_equal Ace::Base::Case, yield("Ace::Base::Case")
    assert_equal Ace::Base::Case, yield("::Ace::Base::Case")
    assert_equal Ace::Base::Case::Dice, yield("Ace::Base::Case::Dice")
    assert_equal Ace::Base::Fase::Dice, yield("Ace::Base::Fase::Dice")
    assert_equal Ace::Gas::Case, yield("Ace::Gas::Case")
    assert_equal Ace::Gas::Case::Dice, yield("Ace::Gas::Case::Dice")
    assert_equal Case::Dice, yield("Case::Dice")
    assert_equal Case::Dice, yield("Object::Case::Dice")
    assert_equal UtilityTestCases, yield("UtilityTestCases")
    assert_equal UtilityTestCases, yield("::UtilityTestCases")
    assert_equal Object, yield("")
    assert_equal Object, yield("::")
    assert_raises(NameError) { yield("UnknownClass") }
    assert_raises(NameError) { yield("UnknownClass::Ace") }
    assert_raises(NameError) { yield("UnknownClass::Ace::Base") }
    assert_raises(NameError) { yield("An invalid string") }
    assert_raises(NameError) { yield("InvalidClass\n") }
    assert_raises(NameError) { yield("Ace::UtilityTestCases") }
    assert_raises(NameError) { yield("Ace::Base::UtilityTestCases") }
    assert_raises(NameError) { yield("Ace::Gas::Base") }
    assert_raises(NameError) { yield("Ace::Gas::UtilityTestCases") }
  end
end

CamelToUnderscore = {
  "Product"               => "product",
  "SpecialGuest"          => "special_guest",
  "ApplicationController" => "application_controller",
  "Area51Controller"      => "area51_controller"
}
