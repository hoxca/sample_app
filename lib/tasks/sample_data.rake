namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    User.create!(common_name: "Example User",
                 first_name: "Example",
                 last_name: "User",
                 nickname: "exuser",
                 email: "user@railstutorial.org",
                 password: "foobar",
                 password_confirmation: "foobar")

    99.times do |n|
      email = "example-#{n+1}@railstutorial.org"
      common_name = Faker::Name.name
      cn = common_name.split(' ')
      first_name  = cn[0]
      nickname  = "nickname"
      last_name = cn[1]
      password  = "password"
      User.create!(common_name: common_name,
                   first_name: first_name,
                   last_name: last_name,
                   nickname: nickname,
                   email: email,
                   password: password,
                   password_confirmation: password)
    end
  end
end
