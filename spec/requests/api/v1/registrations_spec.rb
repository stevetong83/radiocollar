require 'spec_helper'

describe "Mobile Registration" do
  def post_register params = {empty: :empty}
    post "/api/v1/register", Hash[params].to_json,{"CONTENT_TYPE" => "application/json"}
  end

  describe "Register" do
    let(:email) {FactoryGirl.generate :email}
    let(:password) {"password"}

    context "When submitting valid params" do
      before do
        post_register params
      end

      let(:params) {{email: email, password: password }}

      it {User.count.should eq 1}
      it {response.status.should eq 200}
      it {response.should be_success}

    end

    context "When submitting used email params" do
      before do
        @user = FactoryGirl.create :user
        params = {email: @user.email, password: password}
        post_register params
      end

      it {User.count.should eq 1}
      it {response.status.should eq 422}
      it {response.should_not be_success}
    end
  end
end