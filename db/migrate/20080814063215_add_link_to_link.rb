class AddLinkToLink < ActiveRecord::Migration
  def self.up
    add_column :links, :words, :text
  end

  def self.down
    remove_column :links, :words
  end
end
