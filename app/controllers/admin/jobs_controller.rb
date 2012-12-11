class Admin::JobsController < AdminController
  before_filter :fetch_job, :only => [:destroy, :show, :retry]
  
  def retry
    if @job.retry
      respond_to do |format|
        format.html {
          flash[:success] = 'Job is now being retried'
          redirect_to admin_queues_path
        }
      end
    else
      respond to do |format|
        format.html {
          flash[:error] = 'Error while trying to retry job'
          redirect_to admin_queues_path
        }
      end
    end
  end
  
  def destroy
    if @job.delete
      respond_to do |format|
        format.html {
          flash[:success] = 'Removed job'
          redirect_to admin_queues_path
        }
      end
    else
      respond to do |format|
        format.html {
          flash[:error] = 'Error while trying to remove job'
          redirect_to admin_queues_path
        }
      end
    end
  end
  
  protected
  
  def fetch_job
    type, jid, score = params[:id].split('-')
    case type
    when 'retry'
      @job = Sidekiq::RetrySet.new.fetch(score.to_f, jid).first
    when 'scheduled'
      @job = Sidekiq::ScheduledSet.new.fetch(score.to_f, jid).first
    else
      flash[:error] = 'Unknown job type'
      redirect_to admin_queues_path
    end
    
    if @job.nil?
      flash[:error] = "Couldn't find job type:#{type}, jid:#{jid}, score:#{score.to_f}"
      redirect_to admin_queues_path
    end
  end
end
