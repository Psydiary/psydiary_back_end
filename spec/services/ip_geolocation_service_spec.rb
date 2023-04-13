require 'rails_helper'

describe IpGeolocationService do
  describe 'instance methods' do
    context 'location_by(ip)' do
      before(:each) do
        @ip_address = request.remote_ip
        # render plain: "Your IP address is #{ip_address}"
      end
      it 'returns location data based on ip address' do
        VCR.use_cassette('location_by(ip_address)', serialize_with: :json, match_requests_on: [:method, :path]) do
          # location_data = MovieDbService.new.location_by(ip_address)

          # expect(top_rated_movie_data).to be_a Hash
          # expect(top_rated_movie_data[:results]).to be_an Array

          # movie_data = top_rated_movie_data[:results].first

          # expect(movie_data).to have_key :title
          # expect(movie_data[:title]).to be_a String

          # expect(movie_data).to have_key :vote_average
          # expect(movie_data[:vote_average]).to be_a Float
        end
      end
    end
  end
end