class EntriesSweeper < ActionController::Caching::Sweeper
  observe Entry
  
  def after_save(entry)
    expire_cache_for(entry)
  end
  
  def after_destroy(entry)
    expire_cache_for(entry)
  end
    
  private
    def expire_cache_for(entry)
      # Expire the index page now that we added a new entry
      @controller ||= ApplicationController.new
      
      expire_fragment('all_available_feeds')
    end
end