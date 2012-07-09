FactoryGirl.define do

  factory :user do
    sequence(:common_name)           { |n|  "Example User-#{n}" }
    sequence(:nickname)              { |n|  "nick-#{n}" }
    sequence(:last_name)             { |n|  "User-#{n}" }
    sequence(:email)                 { |n|  "User-#{n}@example.com" }
    first_name                       "Example"
    password                         "foobar"
    password_confirmation            "foobar"

    factory :admin do
      admin true
    end
  end

  factory :micropost do
    content "Lorem ipsum"
    user
  end

end
