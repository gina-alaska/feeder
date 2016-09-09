class Import < ActiveRecord::Base
  def queue!
    ImportWorker.perform_async(id)
  end
end
