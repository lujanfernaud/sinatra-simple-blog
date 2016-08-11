require 'sinatra'
require 'haml'
require './model/blog.rb'

helpers do
  def protected!
    return if admin?
    headers['WWW-Authenticate'] = 'Basic realm="Restricted Area"'
    halt 401, "Not authorized."
  end

  def admin?
    @auth ||= Rack::Auth::Basic::Request.new(request.env)
    @auth.provided? and @auth.basic? and @auth.credentials and @auth.credentials == ['admin', 'admin']
  end

  def edit_url
    "<a href='/post/#{params[:id]}/edit'>Edit</a>"
  end

  def delete_url
    "<a href='/post/#{params[:id]}/delete'>Delete</a>"
  end
end

# Locks access to paths in array unless the user is logged in.
['/login', '/post', '/post/:id/edit', '/post/:id/delete'].each do |path|
  before path do
    protected!
  end
end

# Create a new instance of the Blog class and save it in the 'db' variable.
db = Blog.new

# Index (quite obvious).
get '/' do 
  @posts = db.posts
  haml :index
end

# Just a way to trigger the login.
get '/login' do
  redirect '/'
end

# Show a particular post.
get '/post/:id' do
  @post = db.post(params[:id])
  haml :blog_post
end

# Show the form to create a new post.
get '/post' do
  haml :blog_form
end

# Store the information of the new post into the database
# and redirect to the post.
post '/post' do
  id = db.new_post(params[:title], params[:body])
  redirect "/post/#{id}"
end

# Edit a post.
get '/post/:id/edit' do
  @post = db.post(params[:id])
  @title = @post[:title]
  @body = @post[:body]
  haml :blog_form_edit
end

# Send the new information of the edited post to the database
# and redirect to the post.
post '/post/:id/edit' do
  db.update_post(params[:id], params[:title], params[:body])
  redirect "/post/#{params[:id]}"
end

# Shows a preview of the post to delete, 
# and asks for confirmation before deleting it.
get '/post/:id/delete' do
  @post = db.post(params[:id])
  haml :blog_post_delete
end

# Deletes the post from the database and redirects to the index.
post '/post/:id/delete' do 
  db.delete_post(params[:id])
  redirect '/'
end