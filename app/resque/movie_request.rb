class MovieRequest
  @queue = :movies
  
  def self.perform(id)
    movie = Movie.find(id)
    movie.generate
  end
end