class MovieRequest
  include Sidekiq::Worker
  
  def perform(id)
    movie = Movie.find(id)
    movie.generate
    Sunspot.commit
  end
end