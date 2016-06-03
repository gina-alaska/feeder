class Admin::JobsController < AdminController
  before_filter :fetch_job, :only => [:destroy, :show, :retry]

  def retry
    if @job.retry
      flash[:success] = 'Job is now being retried'
    else
      flash[:error] = 'Error while trying to retry job'
    end

    redirect_to admin_queues_path
  end

  def destroy
    if @job.delete
      flash[:success] = 'Removed job'
    else
      flash[:error] = 'Error while trying to remove job'
    end

    redirect_to admin_queues_path
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
      redirect_to admin_queues_path and return
    end

    if @job.nil?
      flash[:error] = "Couldn't find job type:#{type}, jid:#{jid}, score:#{score.to_f}"
      redirect_to admin_queues_path and return
    end
  end
end
