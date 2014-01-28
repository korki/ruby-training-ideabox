require './lib/ideabox/idea'
require './lib/ideabox/idea_store'

describe IdeaStore do
  before(:each) do
    IdeaStore.delete_all
  end

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
    expect(idea.title).to       eq("dream")
    expect(idea.description).to eq("of unicorns and rainbows")
  end

  it "updates an idea" do
    idea = Idea.new("drink", "tomato juice")
    id = IdeaStore.save(idea)

    idea = IdeaStore.find(id)
    idea.title = "cocktails"
    idea.description = "spicy tomato juice with vodka"

    IdeaStore.save(idea)

    expect(IdeaStore.count).to eq(1)

    idea = IdeaStore.find(id)
    expect(idea.title).to       eq("cocktails")
    expect(idea.description).to eq("spicy tomato juice with vodka")
  end  

  it "deletes an idea" do
    id1 = IdeaStore.save Idea.new("song", "99 bottles of beer")
    id2 = IdeaStore.save Idea.new("gift", "micky mouse belt")
    id3 = IdeaStore.save Idea.new("dinner", "cheeseburger with bacon and avocado")

    expect(IdeaStore.all.map(&:title).sort).to eq(["dinner", "gift", "song"])
    IdeaStore.delete(id2)
    expect(IdeaStore.all.map(&:title).sort).to eq(["dinner", "song"])
  end
  
  it "finds by title" do
    IdeaStore.save Idea.new("dance", "like it's the 80s")
    IdeaStore.save Idea.new("sleep", "like a baby")
    IdeaStore.save Idea.new("dream", "like anything is possible")

    idea = IdeaStore.find_by_title("sleep")

    expect(idea.description).to eq("like a baby")
  end


end