class AddNameToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :last_name, :string
    add_column :users, :first_name, :string
    add_column :users, :middle_initial, :string
  end

  def self.down
    remove_column :first_name, :last_name, :middle_initial
  end
end