class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    logger.debug("all ratings: #{@all_ratings}")

    session_params_used = false

    @hilite_col = nil
    if (@selected_ratings_hash == nil)
      logger.debug("allocating selected_ratings hash")
      @selected_ratings_hash = Hash.new
    end

    if params.has_key?(:ratings)
      @selected_ratings_hash = session[:selected_ratings_hash] = 
        params[:ratings]
      logger.debug("selected p ratings: #{@selected_ratings_hash.keys}")
    elsif (session[:selected_ratings_hash] != nil)
      session_params_used = true
      @selected_ratings_hash = session[:selected_ratings_hash]
      logger.debug("selected s ratings: #{@selected_ratings_hash.keys}")
    end

    if params.has_key?(:sort)
      @hilite_col = session[:sort] = params[:sort]
      logger.debug("selected p sort: #{@hilite_col}")
    elsif (session[:sort] != nil)
      session_params_used = true
      @hilite_col = session[:sort]
      logger.debug("selected s sort: #{@hilite_col}")
    end

    if (session_params_used == true) 
    # redirect to the new RESTful url as params have changed
      logger.debug("at least one p is restored from s, redirecting..")
      redirect_to movies_path({:sort=>@hilite_col,
                               :ratings=>@selected_ratings_hash})
    end

    find_args = Hash.new
    find_args[:conditions]=Hash[:rating => @selected_ratings_hash.keys]
    find_args[:order]=@hilite_col

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
