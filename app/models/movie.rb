class Movie < ActiveRecord::Base
  include AASM
  
  aasm :column => :status do
    state :queued, :initial => true
    state :generating
    state :available
    
    event :generate, :after => :create_movie do 
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
  
  
  validates_presence_of :title, :event_at, :duration
  validate :valid_dates
  validate :active_animation
  
  def valid_dates
    errors.add('duration', "is not valid, end date has not occured yet") if self.ends_at > Time.now
  end
  
  def active_animation
    unless self.feed.active_animations.include?(self.duration)
      errors.add('duration', "is not valid, this feed only supports #{self.feed.active_animations.join(', ')} day animations") 
    end
  end

  def to_param
    "#{year}/#{month}/#{day}"
  end

  def slug
    self.feed.slug
  end
  
  def year
    self.event_at.year
  end
  
  def month
    self.event_at.month
  end
  
  def day
    self.event_at.day
  end
  
  def async_generate
    Resque.enqueue(MovieRequest, self.id)
  end
  
  def starts_at
    self.event_at.beginning_of_day
  end
  
  def ends_at
    (self.event_at+(self.duration.to_i-1).days).end_of_day
  end
  
  def entries
    feed.entries.where('event_at >= ? and event_at <= ?', starts_at.utc, ends_at.utc).order('event_at ASC')
  end
  
  def create_movie
    self.path = File.join('/uploads/movies', self.event_at.year.to_s, self.event_at.month.to_s, self.event_at.day.to_s)
    
    self.save!
    
    mencoder_opts = '-mf w=800:h=800:fps=8:type=png -ovc lavc -lavcopts vcodec=mpeg4:mbd=2:trell -oac copy'
    #mencoder_opts = '-oac faac -faacopts br=192:mpeg=4:object=2:raw -channels 2 -srate 48000 -ovc x264 -x264encopts crf=18:nofast_pskip:nodct_decimate:nocabac:global_header:threads=4 -of lavf -lavfopts format=mp4'
    #mencoder_opts = '-ovc x264 -x264encopts crf=18:nofast_pskip:nodct_decimate:nocabac:global_header:threads=4 -of lavf -lavfopts format=mp4'
    #mencoder_opts = '-mf fps=8 -lavcopts vcodec=flv:vbitrate=500:mbd=2:mv0:trell:v4mv:cbp:last_pred=3 -of lavf -ovc lavc'
    frames = Tempfile.new('frames')
    
    entries.each do |e|
      frames << File.join(Rails.root, 'public', e.file.thumb.to_s) + "\n"
    end
    frames.close
    
    filename = File.join(self.id.to_s, duration.to_s + '_day_animation.avi')
    
    tmpfile = File.join(Rails.root, 'tmp/movies', filename)
    FileUtils.mkdir_p(File.dirname(tmpfile))
    
    cmd = "mencoder mf://@#{frames.path} #{mencoder_opts} -o #{tmpfile}"
    system(cmd)
    frames.unlink
    
    to_mp4(tmpfile)
    to_webm(tmpfile)
    
    self.complete
    self.save!
  end
  
  def as_mp4
    as_format(:mp4)
  end
  
  def as_webm
    as_format(:webm)
  end
  
  def as_format(format)
    File.join(self.path, "#{self.duration}_day_animation.#{format}")
  end
  
  def has_mp4?
    has_format?(:mp4)
  end
  
  def has_webm?
    has_format?(:webm)
  end
  
  def has_format?(format)
    File.exists?(File.join(Rails.root, 'public', as_format(format)))
  end
  
  def to_webm(file)
    output = File.join(Rails.root, 'public', self.path, File.basename(file, '.*') + '.webm')
    FileUtils.mkdir_p(File.dirname(output))
    
    opts = "-y -codec:v libvpx -quality good -cpu-used 0 -b:v 600k -maxrate 600k -bufsize 1200k -qmin 10 -qmax 42 -vf scale=-1:480 -threads 0 -codec:a vorbis  -b:a 128k"
    cmd = "ffmpeg -i #{file} #{opts} #{output}"
    system(cmd)
  end
  
  def to_mp4(file)
    output = File.join(Rails.root, 'public', self.path, File.basename(file, '.*') + '.mp4')
    FileUtils.mkdir_p(File.dirname(output))
    
    cmd = "ffmpeg -i #{file} -y -vcodec libx264 -vprofile baseline -preset slow -b:v 500k -maxrate 500k -bufsize 1000k -vf scale=-1:480 -threads 0 -acodec libvo_aacenc -b:a 128k #{output}"
    puts cmd
    system(cmd)
  end
end
