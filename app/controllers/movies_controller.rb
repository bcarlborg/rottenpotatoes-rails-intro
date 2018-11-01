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
#   if they clicked the link in the header.... display using ordered output
#     do ordered display
#   else display in the regular way
    @movies = Movie.all
    session[:sorted_column] = nil

    if params[:sorted_column_param] == "movies"
        @movies = Movie.all.order(title: :asc)
        session[:sorted_column] = "movies"
    elsif params[:sorted_column_param] == "release_date"
        @movies = Movie.all.order(release_date: :asc)
        session[:sorted_column] = "release_date"
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
