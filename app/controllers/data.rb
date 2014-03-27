require 'json'
require 'awesome_print'
require 'net/http'
require 'uri'

def get_metros
'[
{"name":"London","country":"United Kingdom","lat":"51.510697", "long":"-0.125631"},
{"name":"Southampton","country":"United Kingdom","lat":"50.910151", "long":"-1.399635" },
{"name":"Nottingham","country":"United Kingdom","lat":"52.958779", "long":"-1.157702"},
{"name":"Plymouth","country":"United Kingdom","lat":"50.375169", "long":"-4.144842"},
{"name":"Exeter","country":"United Kingdom","lat":"50.721494", "long":"-3.533632"},
{"name":"Leeds","country":"United Kingdom","lat":"53.807827", "long":"-1.547062"},
{"name":"Liverpool","country":"United Kingdom","lat":"53.413953", "long":"-2.994614"},
{"name":"Brighton","country":"United Kingdom","lat":"50.826684", "long":"-0.137432"},
{"name":"Birmingham","country":"United Kingdom","lat":"52.499180", "long":"-1.889724"},
{"name":"Bristol","country":"United Kingdom","lat":"51.460789", "long":"-2.587963"},
{"name":"Newport","country":"United Kingdom","lat":"51.587111", "long":"-2.997993"},
{"name":"Cardiff","country":"United Kingdom","lat":"51.488791", "long":"-3.181694"},
{"name":"Aberdeen","country":"United Kingdom","lat":"57.155488", "long":"-2.093421"},
{"name":"Glasgow","country":"United Kingdom","lat":"55.869717", "long":"-4.253058"},
{"name":"Edinburgh","country":"United Kingdom","lat":"55.957982", "long":"-3.187874"},
{"name":"Newcastle","country":"United Kingdom","lat":"54.984252", "long":"-1.614615"},
{"name":"Manchester","country":"United Kingdom","lat":"53.485118", "long":"-2.248311"}
]'
end

def do_data_call(metro_name)

  api_key = ENV['LAST_FM_API_KEY']

  uri = URI.parse('http://ws.audioscrobbler.com/2.0')
  params = {
    :metro => metro_name,
    :country => "United Kingdom",
    :format => "json",
    :api_key => api_key,
    :limit => "1",
    :method => "geo.getmetroartistchart"
  }

  uri.query = URI.encode_www_form(params)

  http = Net::HTTP.new(uri.host, uri.port)
  request = Net::HTTP::Get.new(uri.request_uri)

  response = http.request(request)
  response.body
end

def get_all_the_data

  metros = JSON.parse(get_metros, symbolize_names: true)
 # metros = metro_hash[:metros][:metro]

  super_result_array = Array.new

  metros.each do |metro|

    data = do_data_call(metro[:name])

    unless data == nil

      result = JSON.parse(data, symbolize_names: true)

      top_artist = result[:topartists][:artist][:name]
      for_metro = result[:topartists][:@attr][:metro]
      medium_image_url = result[:topartists][:artist][:image][1]['#text'.to_sym]
      lat = metro[:lat]
      long = metro[:long]

      super_result_array << { metro: for_metro, top_artist: top_artist, lat: lat, long: long, image_url: medium_image_url }

    end
  end
  super_result_array
end

LastFm::App.controllers :data do
   get :index,  :provides => [ :js] do
      get_all_the_data.to_json
   end
end
