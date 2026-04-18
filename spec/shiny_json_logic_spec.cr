require "./spec_helper"

describe ShinyJsonLogic do
  describe ".apply" do
    it "returns literals as-is" do
      ShinyJsonLogic.apply(JSON.parse("1")).should eq(JSON::Any.new(1_i64))
      ShinyJsonLogic.apply(JSON.parse("\"hello\"")).should eq(JSON::Any.new("hello"))
      ShinyJsonLogic.apply(JSON.parse("true")).should eq(JSON::Any.new(true))
      ShinyJsonLogic.apply(JSON.parse("null")).should eq(JSON::Any.new(nil))
    end

    it "evaluates var" do
      rule = JSON.parse("{\"var\": \"x\"}")
      data = JSON.parse("{\"x\": 42}")
      ShinyJsonLogic.apply(rule, data).should eq(JSON::Any.new(42_i64))
    end

    it "evaluates var with falsy value false" do
      rule = JSON.parse("{\"var\": \"active\"}")
      data = JSON.parse("{\"active\": false}")
      ShinyJsonLogic.apply(rule, data).should eq(JSON::Any.new(false))
    end

    it "evaluates var with default" do
      rule = JSON.parse("{\"var\": [\"missing\", 99]}")
      data = JSON.parse("{}")
      ShinyJsonLogic.apply(rule, data).should eq(JSON::Any.new(99_i64))
    end

    it "evaluates ==" do
      ShinyJsonLogic.apply(JSON.parse("{\"==\": [1, 1]}")).should eq(JSON::Any.new(true))
      ShinyJsonLogic.apply(JSON.parse("{\"==\": [1, 2]}")).should eq(JSON::Any.new(false))
    end

    it "evaluates if" do
      rule = JSON.parse("{\"if\": [true, \"yes\", \"no\"]}")
      ShinyJsonLogic.apply(rule).should eq(JSON::Any.new("yes"))
    end

    it "evaluates +" do
      rule = JSON.parse("{\"+\": [1, 2, 3]}")
      ShinyJsonLogic.apply(rule).should eq(JSON::Any.new(6_i64))
    end

    it "evaluates map" do
      rule = JSON.parse("{\"map\": [{\"var\": \"items\"}, {\"+\": [{\"var\": \"\"}, 1]}]}")
      data = JSON.parse("{\"items\": [1, 2, 3]}")
      ShinyJsonLogic.apply(rule, data).should eq(JSON.parse("[2, 3, 4]"))
    end

    it "evaluates missing" do
      rule = JSON.parse("{\"missing\": [\"a\", \"b\"]}")
      data = JSON.parse("{\"a\": 1}")
      ShinyJsonLogic.apply(rule, data).should eq(JSON.parse("[\"b\"]"))
    end

    it "treats empty object as falsy" do
      rule = JSON.parse("{\"!!\": {}}")
      ShinyJsonLogic.apply(rule).should eq(JSON::Any.new(false))
    end

    it "evaluates reduce" do
      rule = JSON.parse("{\"reduce\": [{\"var\": \"items\"}, {\"+\": [{\"var\": \"current\"}, {\"var\": \"accumulator\"}]}, 0]}")
      data = JSON.parse("{\"items\": [1, 2, 3, 4]}")
      ShinyJsonLogic.apply(rule, data).should eq(JSON::Any.new(10_i64))
    end

    it "var with nil value returns nil not default" do
      rule = JSON.parse("{\"var\": [\"x\", \"default\"]}")
      data = JSON.parse("{\"x\": null}")
      ShinyJsonLogic.apply(rule, data).should eq(JSON::Any.new(nil))
    end
  end
end
