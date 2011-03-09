# Get roles accessible by the current user #----------------------------------------------------
# Role.reflect_on_all_associations(:has_and_belongs_to_many).first.class_name
# => "User" 
#ruby-1.8.7-p302 > Role.reflect_on_all_associations(:has_many).first.class_name
def accessible_permissions
  @accessible_permissions = []
  controllers = Dir.new("#{RAILS_ROOT}/app/controllers").entries
  controllers = controllers.map { |controller|  controller.downcase.gsub("_controller.rb","").singularize if controller =~ /_controller/ }.compact
  puts controllers.inspect
  models = Dir.new("#{RAILS_ROOT}/app/models").entries
  models.each do |model|
    mod = model.downcase.gsub(".rb","")
    if controllers.include?(mod)
      @accessible_permissions <<  mod.camelize.pluralize
    end
  end
  @accessible_permissions
end

private

  def save_permissions(role,role_ids)
    role.permissions.map{|perm|  perm.delete } unless role.permissions.nil?
    unless role_ids.nil?
      role_ids.each do |permission|  
        puts permission.inspect
        p = Permission.new(JSON.parse(permission))
        (p.class.reflect_on_all_associations(:has_many) & p.class.reflect_on_all_associations(:has_and_belongs_to_many)).each { |association|
          role.permissions << Permission.new(
            :role_id => role.id,
            :controller => association.class_name.singularize,
            :ability => p.ability
          )
        }
        role.permissions << p
      end
    end
  end
end

