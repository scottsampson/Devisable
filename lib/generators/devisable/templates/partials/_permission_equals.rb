# Equality check based on the role id, controller, and ability
# 
# @param another_permission The permission to compare against
# @return [Boolean] True if the permissions match role id, controller and ability
def ==(another_permission)
  self.role_id == another_permission.role_id && self.model == another_permission.model && self.ability == another_permission.ability ? true : false
end

