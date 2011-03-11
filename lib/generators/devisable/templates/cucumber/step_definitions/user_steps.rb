Given /^there are no users in the system$/ do
  @users = User.all
  @users.each { |user| user.delete! }
end

When /^I delete the other user$/ do
  id = User.last.id
  find(:xpath, "//table/tr/td/a[@href='/users/#{id}' and @data-method='delete']").click
  #find("table tr td a[@href = '/users/#{id}']").click
end

Given /^there are users in the system$/ do
  @generated_user = User.create!(
    :email => 'generated_user@cloudspace.com',
    :password => 'password',
    :password_confirmation => 'password'
  )
  @generated_user.save
end


Then /^I should have the role "([^"]*)"$/ do |role|
  unless @current_user
    @current_user = User.last
  end
  @current_user.role?(role)
end



