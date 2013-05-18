require 'spec_helper'

feature 'Start new game' do
  scenario 'Starting game with correct credentials' do
    VCR.use_cassette 'init_game' do
      visit '/'
      within('#new_game') do
        fill_in 'game_name', with: 'Jack'
        fill_in 'game_email', with: 'jack-the-sparrow@example.com'
      end
      click_button 'To the battle!'
    end

    page.should have_content 'The battle began'
    within('legend') do
      page.should have_content "Platform45's Navy:"
    end
    within('fieldset div') do
      page.should have_content 'Carrier x1'
      page.should have_content 'Battleship x1'
      page.should have_content 'Destroyer x1'
      page.should have_content 'Submarine x2'
      page.should have_content 'Patrol Boat x2'
    end
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
