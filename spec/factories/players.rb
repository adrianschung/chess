FactoryBot.define do
  factory :player do
    sequence :email do |n|
      "dummyemail100#{n}@gmail.com"
    end
    password 'password'
    playername 'test'
  end
end
