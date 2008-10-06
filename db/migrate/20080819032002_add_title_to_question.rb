class AddTitleToQuestion < ActiveRecord::Migration
  def self.up
    add_column :questions, :title, :text
  end

  def self.down
    remove_column :questions, :title
  end
end
