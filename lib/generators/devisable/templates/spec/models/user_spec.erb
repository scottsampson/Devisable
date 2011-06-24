require 'spec_helper'

describe User do
  before(:each) do
    @role = Role.new({
      :name => 'Admin'
    })
    @role2 = Role.new({
      :name => 'SuperAdmin'
    })
    @role.save!
    @role2.save!
    @user = User.new({:email => 'fred@testsite.com', :password=>'pwfred'})
    @user2 = User.new({:email => 'fred2@testsite.com',:username => 'fred2', :password=>'fred2pw'})
    @user.roles << @role
    @user.save!
    @user2.roles << @role2
    @user2.save!
  end
  
  it "should have the role Admin if assigned the Admin Role" do
    @user.role?('Admin').should be_true
  end
  
  it "should not have the role SuperAdmin if assigned the Admin Role" do
    @user.role?('SuperAdmin').should be_false
  end
  
  it "should have username fred@testsite.com if there is no username" do
    (@user.display_name == 'fred@testsite.com').should be_true
  end
  
  it "should have username fred2 if there is a username and an email" do
    (@user2.display_name == 'fred2').should be_true
  end
  
  it "should only show Fred2 for the superadmins" do
    User.superadmins.include?(@user2).should be_true
    User.superadmins.include?(@user).should be_false
  end
  
  it "should be valid with an email" do
    @user.should be_valid
  end
  
  it "should be valid with a username and email" do
    @user2.should be_valid
  end
  
end
