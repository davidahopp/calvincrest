module ApplicationHelper

  def main_pages
    Refinery::Page.where(parent_id: nil, show_in_menu: true).order('lft asc')
  end

end
