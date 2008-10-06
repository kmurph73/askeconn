class ChangeProfile < ActiveRecord::Migration
  def self.up
    change_column :users, :profile, :text, :default => ""
  end

  def self.down
    change_column :users, :profile, :text
  end
end
