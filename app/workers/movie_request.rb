class MovieRequest
  include Sidekiq::Worker

  def perform(id)
    movie = Movie.find(id)
    movie.generate
    movie.create_movie
    Sunspot.commit
  end
end
