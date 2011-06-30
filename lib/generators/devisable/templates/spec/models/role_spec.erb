require 'spec_helper'

module RoleSpecHelper
  def valid_role_attributes
    {
      :name => "Super Admin"
    }
  end
end

describe Role do
  include RoleSpecHelper
  
  before(:each) do
    @role = Role.new
    @role2 = Role.new({
      :name => 'Scott'
    })
    @user = User.new({:email => 'fred@testsite.com', :password => 'password'})
    @permission = Permission.new({:model => 'User',:ability => 'Add'})
  end
  
  it "should require a name" do
    @role.should_not be_valid
  end
  
  it "should be valid with a name" do
    @role2.should be_valid
  end  
  
  it "should have many users" do
    @role2.users << @user
    @role2.save
    (@role2.users.length > 0).should be_true
  end
  
  it "should have many permissions" do
    @role2.permissions << @permission
    @role2.save
    (@role2.permissions.length > 0).should be_true
  end
  
  
  
end
