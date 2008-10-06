require 'AllowSomeHTML'

class Link < ActiveRecord::Base
  belongs_to :question
  belongs_to :user
  
  validates_length_of       :body,    :within => 3..100

  validates_format_of :body,
                        :with => /https?:\/\/.*/,
                        :message => 'Must start with http://'
end
