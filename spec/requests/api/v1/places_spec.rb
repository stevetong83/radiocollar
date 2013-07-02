require 'spec_helper'

describe "Places" do
  let(:user) {FactoryGirl.create :user}

  describe "index" do
    before {get "/api/v1/places?authentication_token=#{user.authentication_token}"}

    context "with valid params" do
      let(:params) {{authentication_token: user.authentication_token}}
    
      it {response.status.should eq 200}
    end

  end

  describe "create" do
    def post_create params = {empty: :empty}
      post "/api/v1/places", Hash[params].to_json,{"CONTENT_TYPE" => "application/json"}
    end

    before {post_create params}

    context "with valid params" do
      let(:params) {{authentication_token: user.authentication_token, name: 'home', lat: '1.1', long: '1.1'}}

      it {response.status.should eq 200}
      it {response.should be_success}
      it {Place.count.should eq 1}
    end
  end

  # describe "show" do
  #   let(:place) {FactoryGirl.create :place}
  #   def post_place params = {empty: :empty}
  #     get "/api/v1/places/'#{place.id}'", Hash[params].to_json,{"CONTENT_TYPE" => "application/json"}
  #   end
    
  #   before {post_place params}

  #   context "with valid params" do
  #     let(:params) {{authentication_token: user.authentication_token, id: place.id}}

  #     it {response.status.should eq 200}
  #   end
  # end

  # describe "delete" do
  #   def post_delete params = {empty: :empty}
  #     delete "/api/v1/places/'#{place.id}'", Hash[params].to_json,{"CONTENT_TYPE" => "application/json"}
  #   end

  #   context "with valid params" do
  #     let(:params) {{authentication_token: user.authentication_token, id: place.id}}

  #     it {response.status.should eq 200}
  #   end
  # end

end