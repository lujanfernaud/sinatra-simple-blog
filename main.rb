require 'sinatra'
require 'haml'
require './model/blog.rb'

db = Blog.new

get '/' do 
  @posts = db.posts
  haml :index
end

get '/post/:id' do
  @post = db.post(params[:id])
  haml :blog_post
end

get '/post' do
  haml :blog_form
end

post '/post' do
  id = db.new_post(params[:title], params[:body])
  redirect "/post/#{id}"
end