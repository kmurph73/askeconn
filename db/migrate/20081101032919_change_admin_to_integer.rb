class ChangeAdminToInteger < ActiveRecord::Migration
  def self.up
    remove_column :users, :admin
    add_column :users, :admin, :integer
  end

  def self.down
    remove_column :users, :admin
    add_column :users, :admin, :boolean
  end
end