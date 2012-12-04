class FeedsSweeper < ActionController::Caching::Sweeper
  observe Feed
  
  def after_save(feed)
    expire_cache_for(feed)
  end
  
  def after_destroy(feed)
    expire_cache_for(feed)
  end
    
  private
    def expire_cache_for(feed)
      # Expire the index page now that we added a new product
      @controller ||= ApplicationController.new
      
      expire_fragment('all_available_feeds')
    end
end