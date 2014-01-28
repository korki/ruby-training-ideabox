require 'sinatra/base'
require 'rack/test'
require 'capybara'
require 'capybara/dsl'

require './lib/app'

Capybara.app = IdeaboxApp

Capybara.register_driver :rack_test do |app|
  Capybara::RackTest::Driver.new(app, :headers =>  { 'User-Agent' => 'Capybara' })
end

describe "managing ideas" do
  include Capybara::DSL

  after(:each) do
    IdeaStore.delete_all
  end

  it "displays ideas" do
    IdeaStore.save Idea.new("eat", "chocolate chip cookies")
    visit '/'
    expect(page).to have_content("chocolate chip cookies")
  end

  it "manages ideas" do
    # Create a couple of decoys
    IdeaStore.save Idea.new("laundry", "buy more socks")
    IdeaStore.save Idea.new("groceries", "macaroni, cheese")

    # Verify that the decoys are being displayed
    visit '/'
    expect(page).to have_content("buy more socks")
    expect(page).to have_content("macaroni, cheese")

    # Create an idea
    fill_in 'title', :with => 'eat'
    fill_in 'description', :with => 'chocolate chip cookies'
    click_button 'Save'
    expect(page).to  have_content("chocolate chip cookies")

    # Find the newly created idea
    idea = IdeaStore.find_by_title('eat')

    # Click the idea's edit link
    within("#idea_#{idea.id}") do
      click_link 'Edit'
    end

    # Verify that the edit form is correctly filled out
    expect(find_field('title').value).to eq('eat')
    expect(find_field('description').value).to eq('chocolate chip cookies')

    # Change the idea's attributes
    fill_in 'title', :with => 'eats'
    fill_in 'description', :with => 'chocolate chip oatmeal cookies'
    click_button 'Save'

    # Make sure the idea has been updated
    expect(page).to have_content("chocolate chip oatmeal cookies")

    # Make sure the decoys are untouched
    expect(page).to have_content("buy more socks")
    expect(page).to have_content("macaroni, cheese")

    # Make sure the original idea is no longer there
    expect(page).not_to have_content("chocolate chip cookies")

    # Delete the idea
    within("#idea_#{idea.id}") do
      click_button 'Delete'
    end
    # Make sure the idea is gone
    expect(page).not_to have_content("chocolate chip oatmeal cookies")

    # Make sure the decoys are still untouched
    expect(page).to have_content("buy more socks")
    expect(page).to have_content("macaroni, cheese")

  end

  it "allows ranking of ideas" do
    id1 = IdeaStore.save Idea.new("fun", "ride horses")
    id2 = IdeaStore.save Idea.new("vacation", "camping in the mountains")
    id3 = IdeaStore.save Idea.new("write", "a book about being brave")

    visit '/'

    idea = IdeaStore.all[1]
    idea.like!
    idea.like!
    idea.like!
    idea.like!
    idea.like!
    IdeaStore.save(idea)

    within("#idea_#{id2}") do
      3.times do
        click_button '+'
      end
    end

    within("#idea_#{id3}") do
      click_button '+'
    end

    ideas = page.all('li')
    expect(ideas[0].text).to match(/camping in the mountains/)
    expect(ideas[1].text).to match(/a book about being brave/)
    expect(ideas[2].text).to match(/ride horses/)
  end

end