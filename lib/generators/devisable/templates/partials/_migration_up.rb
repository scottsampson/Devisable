create_table :roles_users, :id => false do |t|
    t.references :role, :user
end
execute "insert into roles (name) values ('SuperAdmin')"
execute "insert into roles (name) values ('Admin')"
execute "insert into roles (name) values ('GeneralUser')"
execute "insert into roles_users values ('1','1')"
