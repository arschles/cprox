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
    url_code = env.params.url["code"]?
    halt env, status_code: 401, response: "No URL code found in path" if url_code.nil?
    url = env.params.json["url"]?
    halt env,
      status_code: 401,
      response: "No URL found in JSON" if url.nil?
    db[url_code] = url
    ""
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
