FactoryGirl.define do
  factory :place do
    name "Test Location"
    lat "124"
    long "1234"
    association :user
  end
end
