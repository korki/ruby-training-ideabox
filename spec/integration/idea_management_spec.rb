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
    # Create an idea
    visit '/'
    fill_in 'title', :with => 'eat'
    fill_in 'description', :with => 'chocolate chip cookies'
    click_button 'Save'
    expect(page).to  have_content("chocolate chip cookies")

    # Edit the idea

    # Delete the idea

  end

end