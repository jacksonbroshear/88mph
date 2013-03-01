require 'sinatra'
require 'rubygems'
require 'data_mapper'

# logging database calls for development
DataMapper::Logger.new($stdout, :debug)

# initialize database
DataMapper.setup(:default, ENV['DATABASE_URL'] || "postgres://localhost/timeline")


class Timeline
  include DataMapper::Resource
  
  property :id,             Serial      # An auto-increment integer key
  property :title,          String      # A varchar type string, for short strings
  property :location,       Text      # A text block, for longer string data.
  property :created_at,     DateTime    # A DateTime, for any date you might like.
  
end

DataMapper.finalize

DataMapper.auto_migrate!


get '/' do
  @timelines = Timeline.all
  haml :index
end

post '/create' do
  @timeline = Timeline.create( 
  :title => params[:title],
  :location => params[:location],
  )
  @timeline.save
  redirect '/'
end

get '/timeline' do
  @timeline = Timeline.last
  erb :timeline
end
