require 'spec_helper'

describe SearchController do

  describe "GET 'query'" do
    it "returns http success" do
      get 'query'
      response.should be_success
    end
  end

end
