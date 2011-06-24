Given /^I am signed in as "(.*)"$/ do |email|
  @current_user = User.create!(
    :email => email,
    :password => 'password',
    :password_confirmation => 'password',
    :roles => [Role.create!(:name => 'GeneralUser')]
  )

  Given %{I am on the sign in page}
  When %{I fill in "#{email}" for "Email"}
  And %{I fill in "password" for "Password"}
  And %{I press "Sign in"}
  Then %{I should be on the homepage}
  #And %{I should see "Sign in successful!"}
end

Given /^I have the role "(.*)"$/ do |role|
  @current_user.roles << Role.create!(
    :name => role
    )
  @current_user.save
end

Given /^I only have the role "(.*)"$/ do |role|
  @current_user.roles = [ Role.create!( :name => role) ]
  @current_user.save
end

Given /^I am signed out$/ do
  Given %{I am on the sign out page}
  Then %{I should be on the homepage}
  #And %{I should see "Sign out successful"}
end
