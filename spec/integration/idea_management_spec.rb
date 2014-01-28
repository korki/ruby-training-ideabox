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
end