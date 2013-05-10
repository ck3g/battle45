require 'spec_helper'

feature 'Start new game' do
  scenario 'Starting game with correct credentials' do
    visit '/'
    within('#new_game') do
      fill_in 'game_name', with: 'Jack'
      fill_in 'game_email', with: 'jack-the-sparrow@example.com'
    end
    click_button 'To the battle!'
    page.should have_content 'The battle began'
  end

  scenario 'Cannot start the game with invalid credetials' do
    visit '/'
    within('#new_game') do
      fill_in 'game_name', with: ''
      fill_in 'game_email', with: 'Jack'
    end
    click_button 'To the battle!'
    page.should have_content "can't be blank"
    page.should have_content 'Invalid email format'
  end
end
