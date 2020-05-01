require "kemal"
require "nuummite"
require "./option"
require "./result"
require "json"
require "./get_kvps"
require "./url_and_code"
require "./db"

dbInstance = DB.new
db = dbInstance.getDB

module Cprox
  class PathVarNotFound < Exception
    def initialize(@message : String, @code : UInt16)
    end
  end

  class JSONException < Exception
    def initialize(@message : String, @code : UInt16)
    end
  end

  VERSION = "0.1.0"

  puts "This is cprox version #{VERSION}"
  
  get "/" do
    key_value_pairs = get_kvps(db)
    render "src/views/index.ecr"
  end

  get "/search_form" do |env|
    # TODO: get URL code from query string
    # and then look it up and return it
  end
  
  get "/search/:code" do |env|
    code : String | Nil = env.params.url["code"]?
    if code.nil?
      halt env, status_code: 400, response: "URL code was missing"
    else
      url : String | Nil = db[code]?
      if url.nil?
        halt env, status_code: 404, response: "Code #{code} not found"
      else
        url
      end
    end
  end

  post "/addurl" do |env|
    strings : Tuple(String, String) | Nil = get_url_and_code(env)

    if strings.nil?
      "URL code or URL was missing"
    else
      url = strings[0]
      url_code = strings[1]
      # url, url_code = strings
      db[url_code] = url
      env.redirect "/"
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
