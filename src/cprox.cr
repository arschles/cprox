require "kemal"
require "nuummite"

module Cprox
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
    url_code: String | Nil = env.params.url["code"]?
    if url_code.nil?
      halt env,
        status_code: 401,
        response: "No URL code found in path"
    else
      url_any = env.params.json["url"]
      if !url_any.is_a?(String)
        halt env,
          status_code: 401,
          response: "URL must be a string"
      elsif url_any.nil?
        halt env,
          status_code: 401,
          response: "URL must not be nil"
      else
        url = url_any.as(String)
        db[url_code] = url
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
