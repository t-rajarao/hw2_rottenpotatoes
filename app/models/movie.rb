class Movie < ActiveRecord::Base
  def Movie.all_ratings
    all_ratings = Array.new
    Movie.all.each {|movie|
      all_ratings << movie.rating
    }
    return all_ratings.uniq.sort
  end
end
