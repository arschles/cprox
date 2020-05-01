require "nuummite"

class DB
    @@db = Nuummite.new(".", "cprox.db")
    def getDB
        @@db
    end
end
