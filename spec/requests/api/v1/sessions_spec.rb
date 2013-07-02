require 'spec_helper'

describe "Mobile Sessions" do
  #TODO: Put in spec_helper
  def post_login params = {empty: :empty}
    post create_api_v1_session_path, Hash[params].to_json,{"CONTENT_TYPE" => "application/json"}
  end

  def post_logout params = {empty: :empty}
    #Bah! When I switched over to the RESTful naming it started failing. Bringing this one back to its pre-restful state
    delete "/api/v1/logout", Hash[params].to_json,{"CONTENT_TYPE" => "application/json"}
  end

  let(:user) {FactoryGirl.create :user}

  describe "login" do
    before do
      post_login params
    end

    context "When valid params" do
      let(:params) {{email: user.email, password: user.password}}
      
      it {response.status.should eq 200}
      it {response.should be_success}
      it {JSON.parse(response.body)['authentication_token'].should eq user.authentication_token}
    end

    context "When empty params" do
      let(:params) {{}}

      it {response.status.should eq 401}
      it {response.should_not be_success}
      it {JSON.parse(response.body)['errors'].should eq "Invalid email or password."}
    end

    context "When just email params" do
      let(:params) {{email: user.email}}

      it {response.status.should eq 401}
      it {response.should_not be_success}
      it {JSON.parse(response.body)['errors'].should eq "Invalid email or password."}
    end

    context "When just password params" do
      let(:params) {{password: user.password}}

      it {response.status.should eq 401}
      it {response.should_not be_success}
      it {JSON.parse(response.body)['errors'].should eq "Invalid email or password."}
    end

    context "When unused email params" do
      let(:params) {{email: 'new@email.com', password: 'password'}}

      it {response.status.should eq 401}
      it {response.should_not be_success}
      it {JSON.parse(response.body)['errors'].should eq "Invalid email or password."}
    end

    context "When incorrect password params" do
      let(:params) {{email: user.email, password: 'incorrectpassword'}}

      it {response.status.should eq 401}
      it {response.should_not be_success}
      it {JSON.parse(response.body)['errors'].should eq "Invalid email or password."}
    end
  end

  describe "logout" do
    before do
      post_logout params
    end

    let(:params) {{authentication_token: user.authentication_token}}

    it {response.status.should eq 200}
    it {response.should be_success}
    it {JSON.parse(response.body)['message'].should eq "Logged out successfully"}
  end
end