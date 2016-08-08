require 'sinatra'
require 'haml'
require './model/blog.rb'

configure do
  enable :sessions
  set :session_secret, '1234'
end

helpers do
  def edit_url
    "<a href='/post/#{params[:id]}/edit'>Edit</a>"
  end

  def delete_url
    "<a href='/post/#{params[:id]}/delete'>Delete</a>"
  end
end

db = Blog.new

# Index (quite obvious).
get '/' do 
  @posts = db.posts
  haml :index
end

# Show a particular post.
get '/post/:id' do
  @post = db.post(params[:id])
  haml :blog_post
end

# Extremely simple and not secure login.
get '/login' do
  session[:loggedin] = true
  redirect '/'
end

# Logout.
get '/logout' do
  session[:loggedin] = false
  redirect '/'
end

# Show the form to create a new post.
get '/post' do
  if !session[:loggedin]
    redirect '/'
  end

  haml :blog_form
end

# Store the information of the new post into the database
# and redirect to the post.
post '/post' do
  if !session[:loggedin]
    redirect '/'
  end

  id = db.new_post(params[:title], params[:body])
  redirect "/post/#{id}"
end

# Edit a post.
get '/post/:id/edit' do
  if !session[:loggedin]
    redirect '/'
  end

  @post = db.post(params[:id])
  @title = @post[:title]
  @body = @post[:body]

  haml :blog_form_edit
end

# Send the new information of the edited post to the database
# and redirect to the post.
post '/post/:id/edit' do
  if !session[:loggedin]
    redirect '/'
  end

  db.update_post(params[:id], params[:title], params[:body])
  redirect "/post/#{params[:id]}"
end

# Shows a preview of the post to delete, 
# and asks for confirmation before deleting it.
get '/post/:id/delete' do
  if !session[:loggedin]
    redirect '/'
  end
  
  @post = db.post(params[:id])
  haml :blog_post_delete
end

# Deletes the post from the database and redirects to the index.
post '/post/:id/delete' do
  if !session[:loggedin]
    redirect '/'
  end
  
  db.delete_post(params[:id])
  redirect '/'
end