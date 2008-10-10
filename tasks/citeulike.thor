require 'open-uri'

class Citeulike < Thor

  desc "fetch","Fetches citeulike entries with the given tag"
  method_options :user => :optional
  def fetch(tag)
    url = "http://www.citeulike.org/bibtex/tag/#{tag}"
    url << "/user/#{options[:user]}" if options[:user]
    puts open(url).read
  end

end
