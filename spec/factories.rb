FactoryGirl.define do

  sequence :email do |n|
    "someone#{n}@example.com"
  end

end