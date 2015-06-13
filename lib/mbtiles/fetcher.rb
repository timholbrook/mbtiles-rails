require 'faraday'
require 'typhoeus'
require 'typhoeus/adapters/faraday'
require 'uri'

module MBTiles
  class ParallelFetcher
    def initialize(url, timeout = 30)
      @url = URI.parse(url)
      @conn = Faraday.new(url: @url, request: { timeout: timeout }) do |f|
        f.adapter :typhoeus
      end
    end

    def mock!
      response = Typhoeus::Response.new(code: 200, body: '')
      Typhoeus.stub(/#{@url}/).and_return(response)
    end

    def get(tile_list, access_token)
      responses = []

      @conn.in_parallel do
        tile_list.each do |tile|
          zoom, column, row = tile

          path = [@conn.path_prefix, zoom, column, row].join('/') << ".png#{access_token}"
          responses << @conn.get(path)
        end
      end

      if responses.all? { |r| r.status == 200 }
        responses.map(&:body)
      else
        errs = responses.select { |r| !!r.success? }
        if errs.all? { |e| Utils.valid_image?(e.body) }
          responses.map!(&:body)
        else
          raise RuntimeError, errs.map { |e| { e.status => e.headers } }
        end
      end
    end
  end

  class Fetcher
    def initialize(url, timeout)
      @conn = Faraday.new(url: url, request: {timeout: timeout})
    end

    def get(tile_list, access_token)
      tile_list.map do |tile|
        zoom, column, row = tile
        path = ['/osm', zoom, column, row].join('/') << ".png#{@access_token}"

        @conn.get(path).body
      end
    end
  end
end
