class Sqaauto191192UserRolesAndAuthenticate < ActiveRecord::Migration
  def up
    say 'seed initial - Sqaauto191_192_user_roles_and_authenticate'
    
    say 'initial data for \'roles\' table '
    Role.create(id: 1, name: 'Administrator')
    Role.create(id: 2, name: 'PowerUser')
    Role.create(id: 3, name: 'QA')

    say 'initial data for \'users\' table '
    User.create(id: 1, first_name: 'Khanh', last_name: 'Nguyen', email: 'khanh.cong.nguyen@logigear.com', password: 'e10adc3949ba59abbe56e057f20f883e',is_active: 1)
    User.create(id: 2, first_name: 'Thuong', last_name: 'Dang', email: 'thuong.dang@logigear.com', password: 'e10adc3949ba59abbe56e057f20f883e',is_active: 1)
    User.create(id: 3, first_name: 'Tin', last_name: 'Trinh', email: 'tin.trinh@logigear.com', password: 'e10adc3949ba59abbe56e057f20f883e',is_active: 1)
    User.create(id: 4, first_name: 'Vinh', last_name: 'Ly', email: 'vinh.ly@logigear.com', password: 'e10adc3949ba59abbe56e057f20f883e',is_active: 1)
    User.create(id: 5, first_name: 'Peter', last_name: 'Choi', email: 'pchoi@leapfrog.com', password: 'e10adc3949ba59abbe56e057f20f883e',is_active: 1)
    User.create(id: 6, first_name: 'Cedric', last_name: 'Young', email: 'cyoung@leapfrog.com', password: 'e10adc3949ba59abbe56e057f20f883e',is_active: 1)

    say 'initial data for \'user_role_maps\' table '
    (1..6).each {|n| UserRoleMap.create(user_id: n, role_id: 1)}
  end
end
