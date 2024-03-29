class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    #@movies = Movie.all
    @all_ratings = Movie.all_ratings
    @selected_ratings = []

    @movies = []
    if params.key?(:ratings)
      if params[:ratings].empty?
        session.delete(:ratings)
        # puts "params ratings empty"
      else
        session[:ratings] = params[:ratings].keys
        #puts "params ratings not empty"
      end
    else
      #puts "no params ratings"
    end

    if session.key?(:ratings)
      #params[:ratings].keys.each do |k|
      session[:ratings].each do |k|
      @movies = @movies + Movie.where("rating=?",k)
      @selected_ratings = @selected_ratings + [k]
    end
    else
      @movies = @movies + Movie.all
    end

    sort_symbol = session[:sort_by]
    unless sort_symbol.nil?
      @movies = @movies.sort_by { |m| m.send(sort_symbol) }
    end

  end

  def sort_title
    session[:sort_by] = :title
    session[:title_class] = 'hilite'
    session[:date_class] = ''
    redirect_to movies_path
  end

  def sort_date
    session[:sort_by] = :release_date
    session[:date_class] = 'hilite'
    session[:title_class] = ''
    redirect_to movies_path
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
