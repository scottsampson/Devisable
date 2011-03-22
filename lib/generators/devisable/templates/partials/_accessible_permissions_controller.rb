  # Get roles accessible by the current user #----------------------------------------------------
  # Role.reflect_on_all_associations(:has_and_belongs_to_many).first.class_name
  # => "User" 
  #ruby-1.8.7-p302 > Role.reflect_on_all_associations(:has_many).first.class_name
  def accessible_permissions
    @accessible_permissions = Role.accessible_permissions
  end
end