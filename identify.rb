require "sinatra"
require "open-uri"

get '/identify' do
  content_type :xml
  if !params[:url].nil? 
    identify_with_fits(download_tmp(params[:url]))
  end
end

helpers do
  def download_tmp(url)
    file = open(url) do |io| 
      fname = io.meta['content-disposition'].split(/;/).last.split(/\=/).last.gsub(/"/,'')
      open("tmp/#{fname}", "wb") { |file|
        file.write(io.read)
        file
       }
    end
    return file
  end

  def identify_with_fits(file)
    $stderr.puts filepath = File.expand_path(file.path)
    return %x[/usr/local/fits-0.4.3/fits.sh -i #{filepath}]
  end
end

  
