require 'rubygems'
require 'optparse'
require 'bundler'
require 'bundler/cli'

class DevisableGenerator < Rails::Generators::Base
  source_root File.expand_path("../templates", __FILE__)
  
  @@available_configuration_options = {
    '1' => 'database_authenticatable',
    '2' => 'token_authenticatable',
    '3' => 'oauthable',
    '4' => 'confirmable',
    '5' => 'recoverable',
    '6' => 'registerable',
    '7' => 'rememberable',
    '8' => 'trackable',
    '9' => 'timeoutable',
    '10' => 'validatable',
    '11' => 'lockable'
  }
  @@actual_configuration_options = {
    'config' => ['1','5','6','7','8','10'],
    'twitter_oauth' => [],
    'facebook_oauth' => [],
    'gems' => ['1.1.5','0.1.1','1.5.1','1.5.1'], #devise, warden_oauth, cancan, json_pure
    'registration' => false,
    'denied' => false,
    'extra' => [],
    'new' => false,
    'sudo' => false,
    'url' => 'http://localhost:3000'
  }
  
  def initialize(*runtime_args)
    super(*runtime_args)
    #@tut_args = runtime_args
    #@@actual_configuration_options = @tut_args[1].split(',')
    
    # -c, [--config] [string]    # Configuration Options for devise. ie 1,2,3,7,11
    # -o, [--oauth] [string]    # Oauth secret and key seperated by , (comma). ie 123lk23jjsdfklsd,2l4kljknsdjlsdf
    # -g, [--gems] [string]      # Version of the gems you want to use seperated by Devise,Warden_oauth,Cancan. ie 1.1.5,0.1.1,1.5.1  
    # -r, [--registration] #add this option if you want to add a customized registration controller
    # -d, [--denied]        # add this option if you want to add a customized permission denied message
    # -e, [--extra] [string]         # Extra fields added to the user model. ie first_name:string,last_name:string
    # -s, [--sudo] # add this option if gem commands need to use sudo
    
    
    OptionParser.new do |opts|
      opts.banner = "Usage: autoperf.rb [-c config]"
      
      opts.on("-c", "--config [string]", String, "Devise configuration options") do |v|
        @@actual_configuration_options['config'] = v.split(',')
      end
      opts.on("-t", "--twitteroauth [string]", String, "twitter oauth key and secret") do |v|
        @@actual_configuration_options['twitter_oauth'] = v.split(',')
        if @@actual_configuration_options['twitter_oauth'].length != 2
          throw_error("You must have both key and secret seperated by comma for -to option.")
        end
      end
      opts.on("-o", "--facebookoauth [string]", String, "facebook oauth key, secret, and client_id") do |v|
        @@actual_configuration_options['facebook_oauth'] = v.split(',')
        if @@actual_configuration_options['facebook_oauth'].length != 3
          throw_error("You must have key, secret, and client_id seperated by comma for -fo option.")
        end
      end
      opts.on("-g", "--gems [string]", String, "Gem Version options") do |v|
        @@actual_configuration_options['gems'] = v.split(',')
        if @@actual_configuration_options['gems'].length != 3
          throw_error("You must have 3 gem versions seperated by comma for -g option. ie devise,warden,cancan")
        end
      end
      opts.on("-d", "--denied [string]", String, "Add customized permission denied message") do |v|
        @@actual_configuration_options['denied'] = true
      end
      opts.on("-e", "--extra [string]", String, "Extra fields added to the user model") do |v|
        @@actual_configuration_options['extra'] = v.split(',')
      end
      opts.on("-n", "--new [string]", String, "Is New Project") do |v|
        @@actual_configuration_options['new'] = true
      end
      opts.on("-s", "--sudo [string]", String, "Using sudo for gem commands") do |v|
        @@actual_configuration_options['sudo'] = true
      end
      opts.on("-u", "--url [string]", String, "Root url for your app in development") do |v|
        @@actual_configuration_options['url'] = v
      end
      opts.on("-C", "--cucumber [string]", String, "Include cucumber tests") do |v|
        @@actual_configuration_options['cucumber'] = true
      end
    end.parse!
    execute
  end
  
  def throw_error(error = '')
    puts error
    exit();
  end  
  
  def replace_last_end_in_file_with(filename,rep_str)
    gsub_file filename , /^(.*)end$/m, "\\1" + rep_str + "\nend"
  end
  
  def add_devise_gems
    
    sudo = ''
    if @@actual_configuration_options['sudo']
      sudo = 'sudo '
    end
    gem("devise", @@actual_configuration_options['gems'][0])    
    gem("warden_oauth", :version => @@actual_configuration_options['gems'][1], :git => "git://github.com/scottsampson/warden_oauth.git")    
    gem("cancan", @@actual_configuration_options['gems'][2])    
    gem("json_pure", @@actual_configuration_options['gems'][3])    
    gem("twitter_oauth", @@actual_configuration_options['gems'][4])
    
    # cucumber only gems
    if @@actual_configuration_options['cucumber']
      gem("capybara")
      gem("database_cleaner")
      gem("cucumber-rails")
      gem("cucumber")
      gem("rspec-rails")
    end
    Bundler.with_clean_env do
      output = system("bundle install")
      if !output
        err_str = "Gem conflict.  Please make sure your gem versions in your Gemfile match the following:\n\n"
        err_str += "devise - #{@@actual_configuration_options['gems'][0]}\n"
        err_str += "warden_oauth - #{@@actual_configuration_options['gems'][1]}\n"
        err_str += "cancan - #{@@actual_configuration_options['gems'][2]}\n"
        err_str += "json_pure - #{@@actual_configuration_options['gems'][3]}\n\n\n"
        throw_error(err_str)
      end
    end    
  end    
      
  def generate_devise_user
    extra_args = ''
    for i in 0...@@actual_configuration_options['extra'].length
      extra_args << ' ' + @@actual_configuration_options['extra'][i]
    end
    unless extra_args.include?('username')  
      extra_args << ' username:string'
    end
    generate("devise:install")
    generate("devise","user" + extra_args)
    generate("devise:views")
  end
  
  #takes the options from the command line and
  #replaces the existing devise configuration in the user model
  #with the new one.
  def generate_user_configuration
    rep_str = ''
    @@actual_configuration_options['config'].each do |option|
      rep_str << ', :' + @@available_configuration_options[option]
    end
    rep_str = '  devise ' + rep_str[1..-1] + "\n"
    gsub_file "app/models/user.rb" , /^[ ]*(devise)([^\n]*)(\n)(.*)(\s)/, rep_str
    
    rep_str = load_erb_string('partials/_user_model_methods.erb')
    replace_last_end_in_file_with("app/models/user.rb",rep_str)
    
  end
  
  def get_migration(name)
    basedir = './db/migrate'
    Dir.chdir(basedir)
    file = basedir + '/' + Dir.glob("*" + name + "*").first
    Dir.chdir('../../')
    return file
  end
  
  def load_erb_string(filename, options = {})
    @twitter_secret = @@actual_configuration_options['twitter_oauth'][1]
    @twitter_key = @@actual_configuration_options['twitter_oauth'][0]
    @facebook_secret = @@actual_configuration_options['facebook_oauth'][1]
    @facebook_key = @@actual_configuration_options['facebook_oauth'][0]
    @facebook_client_id = @@actual_configuration_options['facebook_oauth'][2]    
    file_path = File.expand_path("../templates", __FILE__) + '/' + filename
    erb_file = ERB.new(File.read(file_path),0,"%")
    return erb_file.result(binding)
  end
  
  def load_file_string(filename, options = {})
    file_path = File.expand_path("../templates", __FILE__) + '/' + filename
    erb_file = File.read(file_path)
    return erb_file
  end
  
  
  
    
  #checks for oauth
  #if so adds oauth code  
  def check_for_oauth
    @has_twitter_oauth = @@actual_configuration_options['twitter_oauth'].length > 0  ? true : false
    @has_facebook_oauth = @@actual_configuration_options['facebook_oauth'].length > 0  ? true : false
    @has_standard_authentication = @@actual_configuration_options['config'].include?('1') ? true : false
    
    if @has_twitter_oauth || @had_facebook_oauth
      
      @twitter_secret = @@actual_configuration_options['twitter_oauth'][1]
      @twitter_key = @@actual_configuration_options['twitter_oauth'][0]
      @facebook_secret = @@actual_configuration_options['facebook_oauth'][1]
      @facebook_key = @@actual_configuration_options['facebook_oauth'][0]
      @facebook_client_id = @@actual_configuration_options['facebook_oauth'][2]
      @url = @@actual_configuration_options['url']
      #/config/initializers/devise.rb
      template "devise_initializer.erb", "config/initializers/devise.rb"
      
      # remove user password from devise sign in page
      unless @@actual_configuration_options['config'].include?('1')
        gsub_file "app/views/devise/sessions/new.html.erb", "<p><%= f.label :password %><br />\n", ""
        gsub_file "app/views/devise/sessions/new.html.erb", "<%= f.password_field :password %></p>\n", ""
      end
      
      #add twitter_oauth
      keys = load_erb_string('partials/_environments_development.erb')
      append_to_file "config/environments/development.rb", keys
      append_to_file "config/environments/test.rb", keys
      
      #Add correct fields to the table	
      user_migration_file = get_migration("devise_create_user")
      gsub_file user_migration_file, "# t.token_authenticatable", "t.token_authenticatable" 
      fields = load_erb_string('partials/_oauth_user_table_fields.erb')
      insert_into_file user_migration_file, fields, :after => "t.token_authenticatable\n"
      
      #add correct fields to user model
      str = "attr_accessible :default_provider, :username\n"
      insert_into_file "app/models/user.rb", str, :after => "# Setup accessible (or protected) attributes for your model\n"  
      
      generate("model", "oauth_profile user_id:integer provider:string token:string secret:string username:string email:string name:string img_url:string")
            
      insert_into_file "app/models/oauth_profile.rb", "belongs_to :user\n", :after => "class OauthProfile < ActiveRecord::Base\n"
      
      insert_into_file "app/models/user.rb", "has_many :oauth_profiles\n", :after => "class User < ActiveRecord::Base\n"  
      
    end
    
    # Link to "Login With Twitter/Facebook" somewhere in your view
    login_links = load_erb_string('partials/_login_links.erb')
    insert_into_file "app/views/layouts/application.html.erb", login_links, :after => "<body>\n"
  end
  
  #check_for_confirmable
  def confirmable
    if @@actual_configuration_options['config'].include?('4')
      user_migration_file = get_migration("devise_create_user")
      gsub_file user_migration_file, "# t.confirmable", "t.confirmable"
      
      insert_into_file "app/controllers/application_controller.rb", "before_filter :mailer_set_url_options\n", :after => "class ApplicationController < ActionController::Base\n"  
      
      methods = load_erb_string('partials/_application_controller_methods.erb')
      gsub_file "app/controllers/application_controller.rb", "end", methods + "\nend"
    end
  end
  
  #check_for_confirmable
  def lockable
    if @@actual_configuration_options['config'].include?('11')
      user_migration_file = get_migration("devise_create_user")
      gsub_file user_migration_file, "# t.lockable ", "t.lockable "
    end
  end
  
  
  def add_authentication_check_to_controllers
    insert_into_file "app/controllers/application_controller.rb", "before_filter :authenticate_user!, :except => []\n", :after => "class ApplicationController < ActionController::Base\n"
    
    methods = load_erb_string('partials/_application_controller_methods2.erb')
    insert_into_file "app/controllers/application_controller.rb",methods + "\n", :after => "before_filter :authenticate_user!, :except => []\n"
  end
  
  def install_cancan
    generate("cancan:ability")
    #create the Role model
    generate("scaffold","Role name:string")
    generate("model","Permission role_id:integer model:string ability:string")
    #create the Many To Many relationship between users and roles
    generate("migration","UsersHaveAndBelongToManyRoles")
    basedir = './db/migrate'
    Dir.chdir(basedir)
    file = basedir + '/' + Dir.glob("*users_have_and_belong_to_many*").first
    Dir.chdir('../../')
    self_up_migration = load_erb_string('partials/_migration_up.rb')
    self_down_migration = load_erb_string('partials/_migration_down.rb')
    insert_into_file file, self_up_migration, :after => "def self.up\n"
    insert_into_file file, self_down_migration, :after => "def self.down\n"
    insert_into_file "app/models/user.rb", "has_and_belongs_to_many :roles\n", :after => "class User < ActiveRecord::Base\n"
    insert_into_file "app/models/role.rb", "has_and_belongs_to_many :users\n", :after => "class Role < ActiveRecord::Base\n"
    insert_into_file "app/models/role.rb", "has_many :permissions\nvalidates_presence_of :name\n", :after => "has_and_belongs_to_many :users\n"
    insert_into_file "app/controllers/roles_controller.rb", "before_filter :accessible_permissions, :only => [:new, :edit, :show, :update, :create]\nload_and_authorize_resource\n", :after => "class RolesController < ApplicationController\n"
    insert_into_file "app/controllers/roles_controller.rb", "save_permissions(@role,params[:role_ids])\n", :after => "if @role.update_attributes(params[:role])\n"
    
    insert_into_file "app/controllers/roles_controller.rb", "save_permissions(@role,params[:role_ids]) \n", :after => "if @role.save\n"
    insert_into_file "app/models/permission.rb", "belongs_to :role\n", :after => "class Permission < ActiveRecord::Base\n"
    rep_str = load_erb_string('partials/_permission_equals.rb')
    insert_into_file "app/models/permission.rb", rep_str, :after => "belongs_to :role\n"
    
    rep_str = load_erb_string('partials/_ability_class.rb')
    gsub_file "app/models/ability.rb" , /^(.*)end$/m, rep_str
    rep_str = load_erb_string('partials/_user_role.rb')
    insert_into_file "app/models/user.rb", rep_str, :after => "has_and_belongs_to_many :roles\n"
  end

  
  def customize_registration_controller
    template "registrations_controller.erb", "app/controllers/registrations_controller.rb"
    gsub_file "config/routes.rb" , "devise_for :users\n", "devise_for :users,  :controllers => { :registrations => \"registrations\" }\n"  
  end
    
  def customize_permission_denied_error
    if @@actual_configuration_options['denied']
      rep_str = load_erb_string('partials/_access_denied_flash.rb')
      insert_into_file "app/controllers/application_controller.rb", rep_str, :after => "protect_from_forgery\n"    
    end
  end
  
  def create_user_tool
    @show_password = @@actual_configuration_options['config'].include?('1')
    #TODO:  Have to make sure if they have changed the devise_for :users that we account for it here.
    insert_into_file "config/routes.rb", "resources :users", :after => "devise_for :users,  :controllers => { :registrations => \"registrations\" }\n"    
    template "index.erb", "app/views/users/index.html.erb"
    template "new.erb", "app/views/users/new.html.erb"
    template "show.erb", "app/views/users/show.html.erb"
    template "edit.erb", "app/views/users/edit.html.erb"
    template "_form.erb", "app/views/users/_form.html.erb"
    template "users_controller.erb", "app/controllers/users_controller.rb"
  end
  
  def create_roles_tool
    #TODO:  Have to make sure if they have changed the devise_for :users that we account for it here.
    rep_str = load_file_string('partials/_role_permission.rb')
    insert_into_file "app/helpers/roles_helper.rb", rep_str, :after => "module RolesHelper\n"    
    #template "roles_helper.rb", "app/helpers/roles_helper.rb"
    #most of this is done in the scaffold above
    gsub_file "app/views/roles/index.html.erb" , "<td><%= link_to 'Edit', edit_role_path(role) %></td>", "<td><%= link_to_if(can?(:edit, Role), 'Edit', edit_role_path(role)) %></td>"
    rep_str = load_erb_string('partials/_roles_index_delete.erb')
    gsub_file "app/views/roles/index.html.erb" , "<td><%= link_to 'Destroy', role, :confirm => 'Are you sure?', :method => :delete %></td>", rep_str
    
    gsub_file "app/views/roles/show.html.erb" , "<%= link_to 'Edit', edit_role_path(@role) %>", "<%= link_to_if(can?(:edit, Role), 'Edit', edit_role_path(@role)) %>"
    gsub_file "app/views/roles/show.html.erb" , "<p id=\"notice\"><%= notice %></p>", ""
    gsub_file "app/views/roles/_form.html.erb" , /^[\s]*(<div class="actions">)[\s]+(<%= f.submit %>)[\s]+(<\/div>)/m, "<p><%= f.label :permission %></p>\n <ul class=\"no-pad no-bullets\">\n <%= permissions_checkboxes(@role, :permission_ids, @accessible_permissions, @role.id) %>\n </ul>\n <div class=\"actions\">\n      <%= f.submit %>\n    </div>"
    
    
    rep_str = load_erb_string('partials/_accessible_permissions_model.rb')
    gsub_file "app/models/roles.rb" , /^(\s)*end\Z/m, rep_str
    rep_str = load_erb_string('partials/_accessible_permissions_controller.rb')
    gsub_file "app/controllers/roles_controller.rb" , /^(\s)*end\Z/m, rep_str
    gsub_file "app/controllers/roles_controller.rb" , "format.html { redirect_to(roles_url) }", "format.html { redirect_to(roles_url, :notice => 'Role was successfully deleted.') }"
  end
  
  def create_tool_navigation
    empty_directory "app/views/shared"
    template "_admin_nav.erb", "app/views/shared/_admin_nav.html.erb"
    rep_str = load_erb_string('partials/_application_current_tab.rb')
    insert_into_file "app/helpers/application_helper.rb", rep_str, :after => "module ApplicationHelper\n"    
  end
  
  def new_project
    if @@actual_configuration_options['new']
      remove_file "public/index.html"
      insert_into_file "config/routes.rb", "root :to => 'welcome#index'", :after => "resources :users\n"
      template "welcome_controller.erb", "app/controllers/welcome_controller.rb"
      empty_directory "app/views/welcome"
      template "welcome_index.erb", "app/views/welcome/index.html.erb"
      insert_into_file "config/routes.rb", "root :to => 'welcome#index'", :after => "resources :users\n"
      rep_str = load_erb_string('partials/_application_flash.html.erb')
      insert_into_file "app/views/layouts/application.html.erb", rep_str, :after => "<%= render 'shared/admin_nav' %>\n"      
    end
  end
  
  def add_javascript
    rep_str = load_erb_string('partials/_permission_manage.js')
    append_to_file "public/javascripts/application.js", rep_str
  end

  def add_cucumber_tests
    if @@actual_configuration_options['cucumber']
      generate('cucumber:install')
      # features
      template('cucumber/devise.feature', 'features/devise.feature')
      template('cucumber/user.feature', 'features/user.feature')
      template('cucumber/role.feature', 'features/role.feature')
      # step definitions
      template('cucumber/step_definitions/authentication_steps.rb', 'features/step_definitions/authentication_steps.rb')
      template('cucumber/step_definitions/generic_steps.rb', 'features/step_definitions/generic_steps.rb')
      template('cucumber/step_definitions/role_steps.rb', 'features/step_definitions/role_steps.rb')
      template('cucumber/step_definitions/user_steps.rb', 'features/step_definitions/user_steps.rb')
      # support 
      #empty_directory "features/support"
      rep_str = load_erb_string('cucumber/support/_paths_partial.rb')
      insert_into_file('features/support/paths.rb', rep_str, :after => "case page_name\n")
      # this edit to the cucumber env file may be caused by rails 3.0.1 and can be removed after testing
      gsub_file('features/support/env.rb', "require 'cucumber/rails/capybara_javascript_emulation'", "#require 'cucumber/rails/capybara_javascript_emulation'")
      # rake task
      rep_str = load_erb_string('cucumber/_rake_partial.rb')
      insert_into_file('lib/tasks/cucumber.rake', rep_str, :after => "namespace :cucumber do\n")
      gsub_file('lib/tasks/cucumber.rake', "task :cucumber => 'cucumber:ok'", "task :cucumber => ['cucumber:setup_js_with_vnc4server', 'cucumber:ok', 'cucumber:kill_js']")
    end
  end
  
  def add_default_mailer_config
    rep_str = "config.action_mailer.default_url_options = { :host => \"#{@@actual_configuration_options['url']}\" }\n"
    insert_into_file "config/environments/development.rb", rep_str, :after => "config.action_mailer.raise_delivery_errors = false\n"
    insert_into_file "config/environments/test.rb", rep_str, :after => "config.action_mailer.delivery_method = :test\n"
  end
  
  def modify_css
    gsub_file('public/stylesheets/scaffold.css', "#notice {", "#notice, div.notice {")
  end
  
  def add_rspec_tests
    ['ability_spec','permission_spec','role_spec','user_spec'].each do |filename| 
      template('spec/models/#{filename}.erb', 'spec/models/#{filename}.rb')
    end
    template('roles/helpers/roles_helper_spec.erb', 'spec/models/roles_helper_spec.rb')
  end
      
  def execute
    add_devise_gems
    generate_devise_user
    generate_user_configuration
    check_for_oauth
    confirmable
    lockable
    add_authentication_check_to_controllers
    install_cancan
    customize_registration_controller
    customize_permission_denied_error
    create_user_tool
    create_roles_tool
    create_tool_navigation
    new_project
    add_javascript
    add_cucumber_tests
    add_default_mailer_config
    modify_css
    add_rspec_tests
  end

end
