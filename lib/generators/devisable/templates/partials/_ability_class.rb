class Ability
  include CanCan::Ability
    def initialize(user)
    user ||= User.new # guest user
    user.roles.each do |role|
      role.permissions.each do |permission|
        can permission.ability.to_sym, Object::const_get(permission.model)
        if permission.ability.to_s == 'manage'
          ['view','edit','delete','add'].each do |action|
            can action.to_sym, Object::const_get(permission.model)
          end
        end
      end
    end

    if user.role? :super_admin
      can :manage, :all
    end
		#examples of some ways to have certain roles manage certain controllers
		#please see the user views on how to check for the permissions
		#if user.role? :super_admin
		#  can :manage, :all
		#elsif user.role? :product_admin
		#  can [:read, :update, :create, :destroy], [Product, Asset, Issue]
		#elsif user.role? :product_team
		#  can :read, [Product, Asset]
		#  # manage products, assets he owns
		#  can :manage, Product do |product|
		#  can :read, Product, :active => true, :user_id => user.id
		#  can :read, Project, :category => { :visible => true }
		#  can :read, Project, :priority => 1..3
		#end
		#can :manage, Asset do |asset|
		#  asset.assetable.try(:owner) == user
		#end
		#end
		##If you want to add a permissions scaffold to replace the roles_users
		#def initialize(user)
		#  can do |action, subject_class, subject|
		#    user.permissions.find_all_by_action(action).any do |permission|
		#      permission.subject_class == subject_class.to_s &&
		#      (subject.nil? || permission.subject_id.nil? || permission.subject_id == subject.id)
		#    end
		#  end
		#end
  end
end
