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
    code = env.params.url["code"]
    post_body = env.request.body

    if post_body.nil?
      halt env, status_code: 400, response: "no POST body"
    elsif code.nil?
      halt env, status_code: 400, response: "No URL in path"
    else
      parser = JSON::Parser.new(post_body)
      json_any = parser.parse()
      url = json_any["url"]?
      if url.nil?
        halt env, status_code: 400, response: "No URL in JSON body"
      else
        begin
          url = url.as_s
          db[code] = url
        rescue
          halt env, status_code: 400, response: "URL was not a string"
        end
      end
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
