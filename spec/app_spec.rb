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

end