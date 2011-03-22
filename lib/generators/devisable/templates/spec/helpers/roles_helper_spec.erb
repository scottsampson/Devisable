require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the RolesHelper. For example:
#
# describe RolesHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe RolesHelper do
  #pending "add some examples to (or delete) #{__FILE__}"
  
  describe "#permission_checkboxes" do
    it "should contain a model that has controllers" do
      @role = Role.new
      output = permissions_checkboxes(@role, :permission_ids, Role.accessible_permissions, @role.id)
      output['<th>Roles</th>'].should_not == nil
      output['<th>Users</th>'].should_not == nil
    end
    
    it "should not contain a model that does not have a controller" do
      @role = Role.new
      output = permissions_checkboxes(@role, :permission_ids, Role.accessible_permissions, @role.id)
      output['<th>Ability</th>'].should == nil
    end
    
    it "should not contain a model that does not have a controller" do
      @role = Role.new
      output = permissions_checkboxes(@role, :permission_ids, Role.accessible_permissions, @role.id)
      output['<th>Ability</th>'].should == nil
    end
  end
  
  describe "#habtm_checkboxes" do
    it "should contain all roles" do
      Role.new({:name => 'SuperAdmin'}).save
      Role.new({:name => 'Admin'}).save
      Role.new({:name => 'GeneralUser'}).save
      @user = User.new({:email => 'test@tester.com'})
      @accessible_roles = Role.all
      output = habtm_checkboxes(@user, :role_ids, @accessible_roles, :name)
      output['SuperAdmin</label>'].should_not == nil
      output['Admin</label>'].should_not == nil
      output['GeneralUser</label>'].should_not == nil
    end
  end
end
