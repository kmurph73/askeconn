require 'AllowSomeHTML'

class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user
  
  def before_save 
    # text_view field is for View
    # original text field saved for editing
    self.view_body = ae_some_html(self.body)

    # if you don't need to save original text
    # just do
    # self.text = ae_some_html(self.text)
  end
  
  def self.find_most_recent_10
    find(:all, :order => "created_at DESC", :limit => 10)
  end
end
