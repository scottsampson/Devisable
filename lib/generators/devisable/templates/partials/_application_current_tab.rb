# Determines whether the given controller is the current controller
# 
# @param Name of the controller to check against
# @return [Boolean] True if the controller_name parameter matches the current controller nam
def current_tab?(controller_name)
  controller.controller_name == controller_name
end

