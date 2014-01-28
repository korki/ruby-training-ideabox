class IdeaStore
  def self.save(idea)
    @ideas ||= []
    idea.id = next_id
    @ideas << idea
    idea.id
  end

  def self.find(id)
    @ideas.find {|idea| idea.id == id}
  end

  def self.count
    @ideas.length
  end
  
  def self.next_id
    count + 1
  end
end