require "../src/cprox"
require "../src/db"

describe "search" do    
    # You can use get,post,put,patch,delete to call the corresponding route.
    it "returns the right url" do
        code = "mytestcode"
        url="https://twitch.tv/arschles"
        db = DB.new.getDB
        db[code] = url
        get "/search/#{code}"
        response.body.should eq url
    end

    it "returns 404 when code doesn't exist" do
        get "/search/noexist"
        response.status_code.should eq 404
    end
  end
