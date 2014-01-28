require './lib/ideabox'

class IdeaboxApp < Sinatra::Base
  set :root, "./lib/app"

  get '/' do
    erb :index, locals: {ideas: IdeaStore.all}
  end
end