require 'spec_helper'

describe Place do
  describe :set_map_url do 
    before do 
      @url = Place.set_map_url("San Francisco", "37.771008", "-122.41175")
    end

    it {@url.should include "http://localhost:3000"}

  end
end
