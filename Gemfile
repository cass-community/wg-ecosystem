source "https://rubygems.org"
# Same stack as cass.community: Jekyll + minimal-mistakes.
gem "jekyll", "~> 4.3"
gem "minimal-mistakes-jekyll"

group :jekyll_plugins do
  gem "jekyll-sitemap"
  gem "jekyll-include-cache"
  gem "jekyll-link-attributes"
end

# Gems that Ruby is moving out of the standard library
gem "nokogiri"
gem "fiddle"
gem "faraday-retry"
gem "csv"
gem "base64"
gem "bigdecimal"
gem "logger"
gem "webrick"

platforms :windows, :jruby do
  gem "tzinfo", ">= 1", "< 3"
  gem "tzinfo-data"
end
