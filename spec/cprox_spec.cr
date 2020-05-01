require "./spec_helper"
require "spec"
require "../src/get_kvps"
require "../src/url_and_code"
require "nuummite"

describe "get_kvps" do
  it "gets a list of key/value pairs" do
    hash = {
      "one" => "uno",
      "two" => "dos",
      "three" => "tres",
      "four" => "cuatro",
    }
    expected_list = [] of {String, String}

    db_filename = "cprox_get_kvps_test.db"
    db = Nuummite.new(".", db_filename)
    hash.each do |english, spanish|
      db[english] = spanish
      expected_list << {english, spanish}
    end

    get_kvps(db).should eq expected_list

    File.delete(db_filename)
  end
end

describe "get_url_and_code"
  it "gets a string url and a string url code" do
    # mock_env = MockEnv.new("someurl.com", "some_code")
    # get_url_and_code(mock_env).should eq {"someurl.com", "some_code"}
  end
end