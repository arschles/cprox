def get_url_and_code(env) : Tuple(String, String) | Nil
    url = env.params.body["url"]?
    url_code = env.params.body["code"]?
    if url.nil? || url_code.nil?
        nil
    else
        if !url.is_a?(String) || !url_code.is_a?(String)
            nil
        else
            {url.as(String), url_code.as(String)}
        end
    end
end