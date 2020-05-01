def get_kvps(db)
    key_value_pairs = [] of {String, String}
    db.each do |key, value|
    key_value_pairs << {key, value}
    end
    key_value_pairs
end
