require 'spec_helper'

describe 'Frontend' do
  let(:user){FactoryGirl.create(:user)}
  it 'informs users of 401 errors', js: true do
    visit '/'
    page.should have_content 'Radio Collar'
    fill_in 'email', with: user.email
    fill_in 'password', with: user.password+"wrong"
    click 'go'
    sleep 1
    page.should have_content 'failed login attempts'
  end
end