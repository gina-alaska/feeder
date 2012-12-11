module Admin::QueuesHelper
  def job_id(type, job)
    "#{type}-#{job['jid']}-#{job.score}"
  end
end
