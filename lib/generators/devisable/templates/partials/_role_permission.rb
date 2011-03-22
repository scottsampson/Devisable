# Creates checkboxes for a has and belongs to many relationship between ?
#
# @param obj An instance of a model with the specified field
# @param column The attribute of the obj parameter used to determine if the assignment_object is assigned to the obj parameter
# @param assignment_objects A list of objects with a habtm relationship with the obj parameter
# @param assignment_object_display_column The field on the assignment_objects used to create the label for the checkboxes
# @return [String] An html string of checkboxes for the relationship between the obj and assignment_objects
def habtm_checkboxes(obj, column, assignment_objects, assignment_object_display_column)
  obj_to_s = obj.class.to_s.split("::").last.underscore
  field_name = "#{obj_to_s}[#{column}][]"

  html = hidden_field_tag(field_name, "")
  assignment_objects.each do |assignment_obj|
    cbx_id = "#{obj_to_s}_#{column}_#{assignment_obj.id}"
    html += check_box_tag field_name, assignment_obj.id, obj.send(column).include?(assignment_obj.id), :id => cbx_id
    html += label_tag cbx_id, h(assignment_obj.send(assignment_object_display_column))
    html += content_tag(:br)
  end
  html
end

# Creates permission checkboxes for each type of permission and permission category.
# Permission types include manage, read, create, update, and destroy.  They are hardcoded in this method.
#
# @param obj An instance of the Role model or any model with a habtm relationship with Permission
# @param column Not used
# @param controllers A list of controllers that can have permissions applied to them
# @param role_id Id that corresponds to an instance of the role model.  Should refer to the same object as the obj parameter.
# @return [String] Html safe string of permissions checkboxes for each controller and action
def permissions_checkboxes(obj, column, controllers, role_id)
  perms =  obj.permissions
  html = ""
  abilities = ['manage','read','create','update','destroy']
  html += content_tag(:table) do
    html_table = ""
    controllers.each do |controller|
      controller.strip!
      html_table += content_tag(:tr) do
        html_tr = ""
        html_tr += content_tag(:th, controller)
        html_tr += content_tag(:th, "Use")
        html_tr += content_tag(:th, "View")
        html_tr += content_tag(:th, "Add")
        html_tr += content_tag(:th, "Edit")
        html_tr += content_tag(:th, "Delete")
        html_tr.html_safe
      end
      html_table += content_tag(:tr) do 
        html_tr = ""
        html_tr += content_tag(:td," ")
        abilities.each do |ability|
          p = {
            :role_id => role_id,
            :model => controller.singularize,
            :ability => ability
          }

          perm = Permission.new(p)
          checked = perms.include?(perm)
          #checked = false
          html_tr += content_tag(:td) do
            check_box_tag 'role_ids[]',p.to_json,checked, {:id => "permission_#{controller}_#{ability}", :class => "permission_#{ability}"}
          end
        end
        html_tr.html_safe
      end
    end
    html_table.html_safe
  end
  html.html_safe
end

