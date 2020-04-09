require "kemal"
require "nuummite"
require "./option"

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
    resp: Option = Option.new(env.params.url["code"]) {|code| 
      url_any = env.params.json["url"]
      if !url_any.is_a?(String)
        {"url_no_string", 401}
      elsif url_any.nil?
        {"url_nil", 401}
      else
        url = url_any.as(String)
        {code, url}
      end
    }
    if resp.is_a?(Option(Nil))
    if resp.is_a?(Tuple)
      halt env, status_code: resp[1], response: resp[0]
    else
      db[resp]
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
