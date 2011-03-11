Given /^there are no roles in the system$/ do
  @roles = Role.all
  @roles.each { |role| role.delete }
end

Given /^there is only the "([^"]*)" role in the system$/ do |role_name|
  @roles = Role.all
  @roles.each { |role| role.delete unless role.name == role_name }
end


Given /^the "([^"]*)" role has been added to the system$/ do |arg1|
  r = Role.create(:name => arg1)
  r.save
end

Given /^I have the default roles$/ do
  Given "the \"SuperAdmin\" role has been added to the system"
  Given "the \"Admin\" role has been added to the system"
  Given "the \"GeneralUser\" role has been added to the system"
end



# step specificlly for deleting a unique feature
# could theoretically also be used for any role and any controller action
# but the code will get messy
# the user steps has a similar function
When /^I follow "Destroy" for "([^"]*)"$/ do |name|
  id = Role.first(:conditions => {:name => name}).id
  find(:xpath, "//table/tr/td/a[@href = '/roles/#{id}' and @data-method='delete']").click
end
