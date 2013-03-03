class PageCleaner
  def self.clear_static_caching!
    Refinery::Page.all.map(&:url).map{|u|
      [(u if u.is_a?(String)), (u[:path] if u.respond_to?(:keys))].compact.flatten
    }.map{ |u| (u.join('/') || 'index') + '.html' }.each do |page|
      static_file = Rails.root.join(ActionController::Base.page_cache_directory, page)
      self.delete_static_file( static_file )
    end
    self.delete_static_file(Rails.root.join(ActionController::Base.page_cache_directory, 'index.html'))

  end

  def self.delete_static_file static_file
    if static_file.file?
      Rails.logger.warn "Clearing cached page #{static_file.split.last}"
      static_file.delete
    else
      Rails.logger.warn "Couldn't find cache file #{static_file}"
    end
  end

end