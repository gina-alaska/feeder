class AddAdminFlagsToUser < ActiveRecord::Migration
  def change
    add_column :users, :site_admin, :boolean, default: false
    add_column :users, :user_admin, :boolean, default: false
    add_column :users, :feed_admin, :boolean, default: false
    add_column :users, :job_admin, :boolean, default: false
  end
end
