class UrlMine
  require "net/http"
  def self.exists?(url_string)
    url = URI.parse(url_string)
    req = Net::HTTP.new(url.host, url.port)
    req.use_ssl = true if url.scheme == 'https'
    res = req.request_head(url.path)
    return URI(res['location']).exists? if %w(301 302).include?(res.code)
    res.code == '200'
  end
end