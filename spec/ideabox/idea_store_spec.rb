require './lib/ideabox/idea'
require './lib/ideabox/idea_store'

describe IdeaStore do
  it "saves and retrieves an idea" do
    idea = Idea.new("celebrate", "with champagne")
    id1 = IdeaStore.save(idea)

    expect(IdeaStore.count).to eq(1)

    idea = Idea.new("dream", "of unicorns and rainbows")
    id2 = IdeaStore.save(idea)

    expect(IdeaStore.count).to eq(2)

    idea = IdeaStore.find(id1)
    expect(idea.title).to eq("celebrate")
    expect(idea.description).to eq("with champagne")

    idea = IdeaStore.find(id2)
    expect(idea.title).to eq("dream")
    expect(idea.description).to eq("of unicorns and rainbows")
  end
end