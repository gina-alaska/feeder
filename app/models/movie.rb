class Movie < ActiveRecord::Base
  include AASM
  
  aasm :column => :status do
    state :queued, :initial => true
    state :generating, :enter => :create_movie
    state :available
    
    event :generate do 
      transitions :to => :generating, :from => :queued
    end
    
    event :reset do
      transitions :to => :queued, :from => [:generating, :available]
    end
    
    event :complete do
      transitions :to => :available, :from => :generating
    end
  end
  
  # attr_accessible :title, :body
  belongs_to :feed
  
  def starts_at
    (self.at - self.duration.days).beginning_of_day
  end
  
  def ends_at
    self.at.end_of_day
  end
  
  def create_movie
    entries = feed.entries.where('event_at >= ? and event_at <= ?', starts_at, ends_at).order('event_at ASC')
    
    mencoder_opts = '-oac faac -faacopts br=192:mpeg=4:object=2:raw -channels 2 -srate 48000 -ovc x264 -x264encopts crf=18:nofast_pskip:nodct_decimate:nocabac:global_header:threads=4 -of lavf -lavfopts format=mp4'
    #mencoder_opts = '-ovc x264 -x264encopts crf=18:nofast_pskip:nodct_decimate:nocabac:global_header:threads=4 -of lavf -lavfopts format=mp4'
    #mencoder_opts = '-mf fps=8 -lavcopts vcodec=flv:vbitrate=500:mbd=2:mv0:trell:v4mv:cbp:last_pred=3 -of lavf -ovc lavc'
    frames = Tempfile.new('frames')
    
    entries.each do |e|
      frames << File.join(Rails.root, 'public', e.file.to_s) + "\n"
    end
    
    frames.close
    
    output_file = Rails.root.join('public/uploads/movies/', self.id.to_s, duration.to_s + '_day_animation.mp4')
    FileUtils.mkdir_p(File.dirname(output_file))
    
    cmd = "mencoder mf://@#{frames.path} #{mencoder_opts} -o #{output_file}"
    puts system(cmd)
    
    frames.unlink
  end
end
