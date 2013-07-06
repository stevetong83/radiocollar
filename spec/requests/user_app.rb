require 'spec_helper'

describe 'Mobile App' do
  it 'Has capybara', js: true do
    visit '/'
    page.should have_content 'Radio Collar'
  end
end