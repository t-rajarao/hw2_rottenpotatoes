class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    logger.debug("all ratings: #{@all_ratings}")

    @hilite_col = nil

    if (@selected_ratings_hash == nil)
      logger.debug("RAJA: allocating selected_ratings hash")
      @selected_ratings_hash = Hash.new
    end

    find_args = Hash.new

    if params.has_key?(:ratings)
      @selected_ratings_hash = params[:ratings]
      logger.debug("selected ratings: #{@selected_ratings_hash.keys}")
      find_args[:conditions]=Hash[:rating => @selected_ratings_hash.keys]
    end

    if params.has_key?(:sort)
      @hilite_col = params[:sort]
      find_args[:order]=params[:sort]
    end

    logger.debug("find args: #{find_args}")
    @movies = Movie.find(:all, find_args)

  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
