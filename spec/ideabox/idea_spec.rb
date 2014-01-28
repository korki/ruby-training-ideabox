require './lib/ideabox/idea'

describe Idea do
  
  it "has basic attributes" do
    idea = Idea.new("title", "description")
    expect(idea.title).to eq("title")
    expect(idea.description).to eq("description")
  end

  it "is likeable" do
    idea = Idea.new("diet", "carrots and cucumbers")
    expect(idea.rank).to eq(0)
    idea.like!
    expect(idea.rank).to eq(1)
    idea.like!
    expect(idea.rank).to eq(2)
  end

  it "sorts by rank" do
    diet = Idea.new("diet", "cabbage soup")
    exercise = Idea.new("exercise", "long distance running")
    drink = Idea.new("drink", "carrot smoothy")

    exercise.like!
    exercise.like!
    drink.like!

    ideas = [drink, exercise, diet]

    expect(ideas.sort).to eq([diet, drink, exercise])
  end

  it "has an id" do
    idea = Idea.new("dinner", "beef stew")
    idea.id = 1
    expect(idea.id).to eq(1)
  end      
end