FactoryGirl.define do

  factory :user do
    common_name            "Hugues Obolonsky"
    nickname               "hoxca"
    first_name             "Hugues"
    last_name              "Obolonsky"
    email                  "hugh@atosc.org"
    password               "foobar"
    password_confirmation  "foobar"
  end

end
