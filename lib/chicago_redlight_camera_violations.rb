require "chicago_redlight_camera_violations/version"
require 'unirest'

module RedlightCamera
  class Violation
    attr_accessor :intersection, :camera_id, :address, :violation_date, :violations, :x_coordinate, :y_coordinate, :latitude, :longitude, :location

    def initialize(options_hash)
      @intersection = options_hash["intersection"]
      @camera_id = options_hash["camera_id"]
      @address = options_hash["address"]
      @violation_date = options_hash["violation_date"]
      @violations = options_hash["violations"]
      @x_coordinate = options_hash["x_coordinate"]
      @y_coordinate = options_hash["y_coordinate"]
      @latitude = options_hash["latitude"]
      @longitude = options_hash["longitude"]
      @location = options_hash["location"]
    end

    def self.all
      violation_response = Unirest.get("https://data.cityofchicago.org/resource/twfh-866z.json?$limit=100").body
      convert_array_to_objects(violation_response)
    end

    def self.where(search_hash)
      search_string = convert_search_hash_to_string(search_hash)
      violation_response = Unirest.get("https://data.cityofchicago.org/resource/twfh-866z.json?#{search_string}").body
      convert_array_to_objects(violation_response)
    end

    private

    def convert_array_to_objects(violation_array)
      collection = []
      violation_array.each do |violation_hash|
        collection << Violation.new(violation_hash)
      end
      collection
    end

    def convert_search_hash_to_string(search_hash)
      search_array = []
      search_hash.each do |key, value|
        search_array << "#{key}=#{value}"
      end
      search_array.join("&")
    end
  end
end

