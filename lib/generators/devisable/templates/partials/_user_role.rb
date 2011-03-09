def role?(role)
  return !!self.roles.find_by_name(role.to_s.camelize)
end
