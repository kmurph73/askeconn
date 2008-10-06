require 'AllowSomeHTML'

class Question < ActiveRecord::Base
  has_many :answers, :dependent => :delete_all 
  belongs_to :user
  has_many :links, :dependent => :delete_all
  
  acts_as_list
  
  def before_save 
    # text_view field is for View
    # original text field saved for editing
    self.view_body = ae_some_html(self.body)

    # if you don't need to save original text
    # just do
    # self.text = ae_some_html(self.text)
  end
  
  def self.search(search, page)
    paginate :per_page => 30, :page => page,
           :conditions => ['title like ?', "%#{search}%"],
           :order => :position
  end
  
  validates_length_of :title, :within => 4..70

  
  def self.find_most_recent_4
    find(:all, :order => "created_at DESC", :limit => 4)
  end
end
