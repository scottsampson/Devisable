When(/^I sleep for ([^"]*) second[s]?$/) do |time|
  sleep(time.to_i)
end

When(/^I output the page source$/) do
  puts source
end

When(/^I fill in the following checkboxes with categories:$/) do |permissions_table|
  permissions_table.hashes.each do |perm|
    And %{I check "permission_#{perm['category']}_#{perm['permission']}"} 
  end
end

When(/^I debug$/) do
  # only works if you include the ruby-debug gem
  debugger
end

Then /^I should see a span with the title "([^"]*)"$/ do |title|
  page.should have_xpath("//span[@title='#{title}']")
end

