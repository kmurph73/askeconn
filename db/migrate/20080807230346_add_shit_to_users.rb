class AddShitToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :profile, :text
    add_column :users, :birthday, :date
    add_column :users, :country, :string
    add_column :users, :quote, :text
    add_column :users, :image_url, :string
  end

  def self.down
    remove_column :users, :profile, :text, :birthday, :country, :quote, :image_url
  end
end
