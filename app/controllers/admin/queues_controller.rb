require 'sidekiq'

class Admin::QueuesController < AdminController
  before_filter :fetch_stats
  
  def index
    @scheduled = Sidekiq::ScheduledSet.new
    @retry = Sidekiq::RetrySet.new
  end
  
  def show
    @queue = Sidekiq::Queue.new(params[:id])
  end
  
  protected
  
  def fetch_stats
    @stats = Sidekiq::Stats.new
    @processed_count = @stats.processed
    @failed_count = @stats.failed
    @enqueued_count = @stats.enqueued
    @scheduled_count = Sidekiq::ScheduledSet.new.size
    @retry_count = Sidekiq::RetrySet.new.size
    @busy_count = workers.size
    @queues = @stats.queues
  end
  
  def retries_with_score(score)
    Sidekiq.redis do |conn|
      results = conn.zrangebyscore('retry', score, score)
      results.map { |msg| Sidekiq.load_json(msg) }
    end
  end
  
  def workers
    @workers ||= begin
      Sidekiq.redis do |conn|
        conn.smembers('workers').map do |w|
          msg = conn.get("worker:#{w}")
          msg ? [w, Sidekiq.load_json(msg)] : nil
        end.compact.sort { |x| x[1] ? -1 : 1 }
      end
    end
  end
end
