class AddUsersEmailIndexes < ActiveRecord::Migration
  def up
    add_index( :users, :email, { :name => "users_email_index", :unique => true } )
  end

  def down
    remove_index(:users, :column => :email)
  end
end
