def ==(another_permission)
  self.role_id == another_permission.role_id && self.model == another_permission.model && self.ability == another_permission.ability ? true : false
end

