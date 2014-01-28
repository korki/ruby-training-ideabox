require 'sinatra/base'
require 'rack/test'
require './lib/app'


describe IdeaboxApp do
  include Rack::Test::Methods
  
  before(:each) do
    IdeaStore.delete_all
  end

  def app
    IdeaboxApp
  end

  it "displays a list of ideas" do
    IdeaStore.save Idea.new("dinner", "spaghetti and meatballs")
    IdeaStore.save Idea.new("drinks", "imported beers")
    IdeaStore.save Idea.new("movie", "The Matrix")

    get '/'

    [
      /dinner/, /spaghetti/,
      /drinks/, /imported beers/,
      /movie/, /The Matrix/
    ].each do |content|
      expect(last_response.body).to match(content)
    end
  end

  it "stores an idea" do
    post '/', title: 'costume', description: "scary vampire"

    expect(IdeaStore.count).to eq(1)

    idea = IdeaStore.all.first
    expect(idea.title).to eq("costume")
    expect(idea.description).to eq("scary vampire")
  end

  it "updates an idea" do
    id = IdeaStore.save Idea.new('sing', 'happy songs')

    put "/#{id}", {title: 'yodle', description: 'joyful songs'}

    expect(last_response.status).to eq(302)

    idea = IdeaStore.find(id)
    expect(idea.title).to eq('yodle')
    expect(idea.description).to eq('joyful songs')
  end

  it "deletes an idea" do
    id = IdeaStore.save Idea.new('breathe', 'fresh air in the mountains')

    expect(IdeaStore.count).to eq(1)

    delete "/#{id}"

    expect(last_response.status).to eq(302)
    expect(IdeaStore.count).to eq(0)
  end

  it "likes an idea" do
    id = IdeaStore.save Idea.new('run', 'really, really fast')

    post "/#{id}/like"

    expect(last_response.status).to eq(302)

    idea = IdeaStore.find(id)
    expect(idea.rank).to eq(1)
  end
  
end