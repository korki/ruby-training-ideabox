class IdeaStore
  def self.save(idea)
    all
    if idea.new?
      idea.id = next_id
      all << idea
    end
    idea.id
  end

  def self.all
    @ideas ||= []
  end

  def self.find(id)
    all.find {|idea| idea.id == id}
  end

  def self.count
    all.length
  end
  
  def self.next_id
    count + 1
  end

  def self.delete(id)
    all.delete find(id)
  end

  def self.delete_all
    @ideas = []
  end

  def self.find_by_title(title)
    all.find { |idea| idea.title == title }
  end
end