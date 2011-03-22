# Determines whether or not a user has a role
#
# @param role Name of the role to search for
# @return [Boolean] True if the user has the specified role
def role?(role)
  return !!self.roles.find_by_name(role.to_s.camelize)
end
