class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    @ratings_params = [] 

    @movies = Movie.all

    if not session[:ratings]
        session[:ratings] = @all_ratings
    end

    if not session.has_key?(:sorted_column) or session[:sorted_column].nil?
        session[:sorted_colum] = "no_sort"
    end


    if params[:ratings]
        session[:ratings] = params[:ratings].keys  
    end

    if params[:sorted_column]
        session[:sorted_column] = params[:sorted_column]
    end 
 
 
    if params.has_key?(:ratings) and not params.has_key?(:sorted_column)
        redirect_to movies_path({:ratings => params[:ratings], :sorted_column =>session[:sorted_colum]}) 
        return

    elsif not params.has_key?(:ratings) and params.has_key?(:sorted_column)
        ratings_hash = {}
        session[:ratings].each {|rating| ratings_hash[rating] = "1"} 
        redirect_to movies_path({:ratings => ratings_hash, :sorted_column => session[:sorted_column]})
        return

    end
    
     
    if session[:sorted_column] == "movies"
        @movies = Movie.where({rating: session[:ratings]}).order(title: :asc)

    elsif session[:sorted_column] == "release_date"
        @movies = Movie.where({rating: session[:ratings]}).order(release_date: :asc)

    elsif session[:sorted_column] == "no_sort"
        @movies = Movie.where({rating: session[:ratings]})

    end

  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
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
