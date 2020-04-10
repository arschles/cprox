require "kemal"
require "nuummite"
require "./option"
require "./result"
require "json"

module Cprox
  class PathVarNotFound < Exception
    def initialize(@message : String, @code : UInt16)
    end
  end

  class JSONException < Exception
    def initialize(@message : String, @code : UInt16)
    end
  end

  db = Nuummite.new(".", "cprox.db")

  VERSION = "0.1.0"

  puts "This is cprox version #{VERSION}"
  
  get "/" do
    db.each do |key, value|
      "#{key} ==> #{value}"
    end
  end

  get "/forward/:code" do |env|
    url_code = env.params.url["code"]?
    if !url_code.nil?
      url = db[url_code]?
      if !url.nil?
        env.redirect url 
      else
        "Code #{url_code} isn't registered"
      end
    else
      "Url code not found"
    end
  end

  post "/code/:code" do |env|
    begin
      json_not_found = JSONException.new message: "url not found in JSON", code: 401
      json_not_string = JSONException.new message: "URL is not a string", code: 401
      body_io : IO | Nil = env.request.body
      url : String = Result.new(body_io).map { |val|
        # get the entire body
        val.gets_to_end
      }.map { |val|  
        parser = JSON::Parser.new(val)
        any = parser.parse()
      }.flat_map {|val|
        # check for nil
        if val.nil?
          Err.new json_not_found
        else
          Ok.new val
        end
      }.flat_map { |val|
        # check for whether it's a string
        begin
          Ok.new(val.as(String))
        rescue
          Err.new(json_not_string)
        end
      }
      url_code = Result.new(env.params.url["code"]?).or_raise(
        PathVarNotFound.new message: "code not found in URL",
          code: 401
      )

      db[url_code] = url
      "Ok"
    rescue e : JSONException | PathVarNotFound
      halt env, status_code: e.code, response: e.code
    else
      halt env, status_code: 500, response: "Unknown error"
    end
  end

  delete "/code/:code" do |env|
    url_code = env.params.url["code"]?
    if !url_code.nil?
      db.delete(url_code)
      "deleted code #{url_code}"
    else
      "Code #{url_code} not found"
    end
  end

  Kemal.run
end
