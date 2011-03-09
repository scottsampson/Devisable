class RegistrationsController < Devise::RegistrationsController
  self.view_paths = ['app/views/devise','app/views']
  
  # Overiding the create controller because we are assigning the General User role to every user 
  # POST /resource/sign_up
  def create
    build_resource

    if resource.save
      resource.roles << Role.find_by_name('GeneralUser') unless User.count() == 1
      resource.save
      set_flash_message :notice, :signed_up
      sign_in_and_redirect(resource_name, resource)
    else
      clean_up_passwords(resource)
      render_with_scope :new
    end
  end
end