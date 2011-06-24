require 'spec_helper'

describe Ability do
  
  before(:each) do
    @role = Role.new({
      :name => 'SuperAdmin'
    })
    
    @user = User.new({:email => 'fred@testsite.com', :username=>'fred', :password=>'pwfred'})
    @user.roles << @role
    @role.permissions << Permission.new({:model => 'Role',:ability => 'Add'})
    @role.permissions << Permission.new({:model => 'Role',:ability => 'Edit'})
    @role.permissions << Permission.new({:model => 'Role',:ability => 'Delete'})
    @role.permissions << Permission.new({:model => 'Role',:ability => 'View'})
    @role.save!
    @user.save!
    @user_ability = Ability.new(@user)
    
    @role2 = Role.new({
      :name => 'RoleUser'
    })
    
    @user2 = User.new({:email => 'terry@testsite.com', :username=>'terry', :password=>'pwterry'})
    @user2.roles << @role2
    @role2.permissions << Permission.new({:model => 'Role',:ability => 'add'})
    @role2.permissions << Permission.new({:model => 'Role',:ability => 'edit'})
    @role2.permissions << Permission.new({:model => 'Role',:ability => 'delete'})
    @role2.permissions << Permission.new({:model => 'Role',:ability => 'View'})
    @role2.save!
    @user2.save!
    @user_ability2 = Ability.new(@user2)
    
  end
  
  it "SuperAdmin Can Edit/add/delete/ Roles and Users" do
    @user_ability.can?(:view, Role).should be_true
    @user_ability.can?(:add, Role).should be_true
    @user_ability.can?(:edit, Role).should be_true
    @user_ability.can?(:delete, Role).should be_true
    
    @user_ability.can?(:view, User).should be_true
    @user_ability.can?(:add, User).should be_true
    @user_ability.can?(:edit, User).should be_true
    @user_ability.can?(:delete, User).should be_true
  end
  
  it "User with Role Permissions Can Edit/add/delete/ Roles" do
    @user_ability2.can?(:view, Role).should be_true
    @user_ability2.can?(:add, Role).should be_true
    @user_ability2.can?(:edit, Role).should be_true
    @user_ability2.can?(:delete, Role).should be_true
  end
  
  it "User with Role Permissions Can NOT Edit/add/delete/ User" do
    @user_ability2.can?(:view, User).should be_false
    @user_ability2.can?(:add, User).should be_false
    @user_ability2.can?(:edit, User).should be_false
    @user_ability2.can?(:delete, User).should be_false
  end

end
