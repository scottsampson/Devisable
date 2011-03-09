when /the sign up page/
  new_user_registration_path
when /the sign in page/
  new_user_session_path
when /the sign out page/
  #should be destory_user_session_path
  '/users/sign_out'
when /the forgot password page/
  '/users/password/new'
when /the forgot password submitted page/
  '/users/password'
when /the users page/
  users_path
when /the other user's edit page/
  edit_user_path(User.last)
when /that role's view page/
  role_path(Role.last)
when /that user's view page/
  user_path(User.last)

