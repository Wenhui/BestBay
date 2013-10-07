module ItemsHelper

  def correct_item?
    current_user.watched_items.find_by_id(params[:id]).nil? && current_user.items.find_by_id(params[:id]).nil?
  end

  def watched?
    !current_user.watched_items.find_by_id(params[:id]).nil?
  end

  def self_posted_item?
  	current_user.items.find_by_id(params[:id]).nil?
  end

end
  