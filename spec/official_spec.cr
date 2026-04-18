require "./spec_helper"

describe ShinyJsonLogic do
  tests_dir = ENV["OFFICIAL_TESTS_DIR"]?

  if tests_dir && Dir.exists?(tests_dir)
    paths = Dir.glob(File.join(tests_dir, "**/*.json")).sort

    describe "official tests (json-logic/.github)" do
      paths.each do |path|
        cases = JSON.parse(File.read(path))
        next unless cases.raw.is_a?(Array(JSON::Any))

        cases.as_a.each_with_index do |testcase, index|
          next unless testcase.raw.is_a?(Hash(String, JSON::Any))
          tc = testcase.as_h
          next unless tc.has_key?("rule")

          desc = tc["description"]?.try(&.as_s?) || "test ##{index}"

          it "#{path.split("/").last}: #{desc}" do
            rule   = tc["rule"]
            data   = tc["data"]? || JSON::Any.new(nil)
            expected = tc["result"]?
            error_expected = tc["error"]?

            begin
              result = ShinyJsonLogic.apply(rule, data)
              if error_expected
                fail "Expected error #{error_expected.inspect} but got result #{result.inspect}"
              else
                result.should eq(expected)
              end
            rescue e : ShinyJsonLogic::Errors::Base
              if error_expected
                # Compare payload hash
                payload_any = JSON::Any.new(e.payload)
                payload_any.should eq(error_expected)
              else
                fail "Unexpected error: #{e.message} (expected result #{expected.inspect})"
              end
            end
          end
        end
      end
    end
  else
    it "skipped: set OFFICIAL_TESTS_DIR to run official tests" do
      pending!
    end
  end
end
