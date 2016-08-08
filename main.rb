require 'sinatra'
require 'haml'
require './model/blog.rb'

configure do
  enable :sessions
  set :session_secret, '1234'
end

helpers do
  def edit_url
    "<a href='/post/#{params[:id]}/edit'>edit</a>"
  end
end

db = Blog.new

get '/' do 
  @posts = db.posts
  haml :index
end

get '/post/:id' do
  @post = db.post(params[:id])
  haml :blog_post
end

get '/login' do
  session[:loggedin] = true
  redirect '/'
end

get '/logout' do
  session[:loggedin] = false
  redirect '/'
end

get '/post' do
  if !session[:loggedin]
    redirect '/'
  end

  haml :blog_form
end

post '/post' do
  if !session[:loggedin]
    redirect '/'
  end

  id = db.new_post(params[:title], params[:body])
  redirect "/post/#{id}"
end

get '/post/:id/edit' do
  if !session[:loggedin]
    redirect '/'
  end

  @post = db.post(params[:id])
  @title = @post[:title]
  @body = @post[:body]

  haml :blog_form_edit
end

post '/post/:id/edit' do
  if !session[:loggedin]
    redirect '/'
  end

  db.update_post(params[:id], params[:title], params[:body])
  redirect "/post/#{params[:id]}"
end