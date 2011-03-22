# Get roles accessible by the current user 
# Usage:
#   Role.reflect_on_all_associations(:has_and_belongs_to_many).first.class_name => "User" 
#   Role.reflect_on_all_associations(:has_many).first.class_name
# @return [Array] Array of permissions for the current user
def self.accessible_permissions
  @accessible_permissions = []
  controllers = Dir.new("#{RAILS_ROOT}/app/controllers").entries
  controllers = controllers.map { |controller|  controller.downcase.gsub("_controller.rb","").singularize if controller =~ /_controller/ }.compact
  models = Dir.new("#{RAILS_ROOT}/app/models").entries
  models.each do |model|
    mod = model.downcase.gsub(".rb","")
    if controllers.include?(mod)
      @accessible_permissions <<  mod.camelize.pluralize
    end
  end
  @accessible_permissions
end

  # Save permissions all permissions for a single role
  # First deletes all permissions for the role, then loops through the input and saves new permissions
  #
  # @param role Role To reset permisisons on
  # @param role_ids A list of permissions to apply to the role
  def save_permissions(role_ids)
    permissions.map{|perm|  perm.delete } unless permissions.nil?
    unless role_ids.nil?
      role_ids.each do |permission|  
        p = Permission.new(JSON.parse(permission))
        (p.class.reflect_on_all_associations(:has_many) & p.class.reflect_on_all_associations(:has_and_belongs_to_many)).each { |association|
          permissions << Permission.new(
            :role_id => id,
            :controller => association.class_name.singularize,
            :ability => p.ability
          )
        }
        permissions << p
      end
    end
  end
  
end

