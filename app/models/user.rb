require 'digest/sha1'
require 'AllowSomeHTML'

class User < ActiveRecord::Base
  has_many :questions
  # users will only have answers if they are an admin.  i figure i'd enforce the
  # constraints via the program, rather the database.  better way?
  has_many :answers
  # posted links for further reading under questions
  has_many :links
  
  def before_save 
    # text_view field is for View
    # original text field saved for editing
    self.view_profile = ae_some_html(self.profile) if self.profile
    self.view_quote = ae_some_html(self.quote) if self.quote
    # if you don't need to save original text
    # just do
    # self.text = ae_some_html(self.text)
  end
  
  def self.search_admin(search, page)
    paginate :per_page => 30, :page => page,
           :conditions => ['login like ? AND admin like ?', "%#{search}%", 1],
           :order => :login
  end
  
  def self.search_user(search, page)
    paginate :per_page => 30, :page => page,
           :conditions => ['login like ? AND admin like ?', "%#{search}%", 0],
           :order => :login
  end
  
  # Virtual attribute for the unencrypted password
  attr_accessor :password
  attr_accessor :current_password

  validates_presence_of     :login, :email
  validates_presence_of     :password,                   :if => :password_required?
  validates_presence_of     :password_confirmation,      :if => :password_required?
  validates_length_of       :password, :within => 4..40, :if => :password_required?
  validates_confirmation_of :password,                   :if => :password_required?
  validates_length_of       :login,    :within => 3..40
  validates_length_of       :email,    :within => 3..100
  validates_uniqueness_of   :login, :email, :case_sensitive => false
  before_save :encrypt_password
  
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :email, :password, :password_confirmation, :birthday, :profile,
                  :last_name, :middle_initial, :country, :quote, :image_url
                  
  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate(login, password)
    u = find_by_login(login) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  # Encrypts some data with the salt.
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  def authenticated?(password)
    crypted_password == encrypt(password)
  end

  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at 
  end

  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    remember_me_for 2.weeks
  end

  def remember_me_for(time)
    remember_me_until time.from_now.utc
  end

  def remember_me_until(time)
    self.remember_token_expires_at = time
    self.remember_token            = encrypt("#{email}--#{remember_token_expires_at}")
    save(false)
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save(false)
  end

  # Returns true if the user has just been activated.
  def recently_activated?
    @activated
  end

  protected
    # before filter 
    def encrypt_password
      return if password.blank?
      self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--") if new_record?
      self.crypted_password = encrypt(password)
    end
      
    def password_required?
      crypted_password.blank? || !password.blank?
    end
    
    
  end 

    
