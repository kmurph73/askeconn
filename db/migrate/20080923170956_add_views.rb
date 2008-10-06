class AddViews < ActiveRecord::Migration
   def self.up
     add_column :users, :view_profile, :text
     add_column :users, :view_quote, :text
     add_column :questions, :view_body, :text
     add_column :answers, :view_body, :text
   end

   def self.down
     remove_column :users, :view_profile
     remove_column :users, :view_quote
     remove_column :questions, :view_body
     remove_column :answers, :view_body
   end
 end