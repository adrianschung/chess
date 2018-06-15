require 'rails_helper'
require 'support/omniauth'

feature 'Visitor signs up with social media authentication' do

  scenario "visitor signs up with facebook" do
    visit '/'
    expect(page).to have_content('Sign in with Facebook')
    set_omniauth(:provider => :facebook)
    click_link('Sign in with Facebook')
    expect(page).to have_content('Sign Out')
  end

  scenario "visitor signs up with google" do
    visit '/'
    expect(page).to have_content('Sign in with Google')
    set_omniauth(:provider => :google_oauth2)
    click_link('Sign in with Google')
    expect(page).to have_content('Sign Out')
  end

end
