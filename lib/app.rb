require './lib/ideabox'

class IdeaboxApp < Sinatra::Base
  set :root, "./lib/app"

  get '/' do
    erb :index, locals: {ideas: IdeaStore.all}
  end

  post '/' do
    idea = Idea.new(params[:title], params[:description])
    IdeaStore.save(idea)
    redirect '/'
  end  
end