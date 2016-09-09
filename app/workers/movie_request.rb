class MovieRequest
  include Sidekiq::Worker

  def perform(id)
    movie = Movie.find(id)
    movie.create_movie
  end
end
