require "kemal"
require "nuummite"

# TODO: Write documentation for `Cprox`

def get_code(env)
  env.params.url["code"]
end


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
    url_code = get_code(env)
    begin
      url = db[url_code]
      env.redirect url
    rescue
      "Code #{url_code} not found"
    end
  end

  post "/code/:code" do |env|
    url_code = get_code(env)
    begin
      url = env.params.json["url"].as(String)
      db[url_code] = url
      "registered code #{url_code} for #{url}"
    rescue
      "Code #{url_code} not found"
    end
  end

  delete "/code/:code" do |env|
    begin
      url_code = get_code(env)
      db.delete(url_code)
      "deleted code #{url_code}"
    rescue
      "Code #{url_code} not found"
    end
  end

  Kemal.run
end
