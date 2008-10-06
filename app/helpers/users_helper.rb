module UsersHelper
  def current_user?
    logged_in? && current_user.id == params[:id].to_i
  end
  
  def your_link?(link)
    logged_in? && current_user.id == link.user_id
  end
  
  def full_name(user)
    user.first_name + " " + user.last_name
  end
end