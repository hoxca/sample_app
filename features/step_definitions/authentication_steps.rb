Given /^a user visits the signin page$/ do
  visit signin_path
end

When /^he submits invalid signin information$/ do
  click_button "Sign in"
end

Then /^he should see an error message$/ do
    page.should have_selector('div.alert.alert-error')
end

Given /^the user has an account$/ do
  @user = User.create(common_name: "Example User",
                      nickname: "User nick",
                      first_name: "Example",
                      last_name: "User",
                      email: "user@example.com",
                      password: "foobar", password_confirmation: "foobar")
end

When /^the user submits valid signin information$/ do
  fill_in "Email",    with: @user.email
  fill_in "Password", with: @user.password 
  click_button "Sign in"
end

Then /^he should see his profile page$/ do
  page.should have_selector('title', text: @user.nickname)
end

Then /^he should see a signout link$/ do
  page.should have_link('Sign out', href: signout_path)
end

