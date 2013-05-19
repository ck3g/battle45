require 'spec_helper'

feature 'Launch salvos' do
  given!(:user) { create :user }

  background do
    VCR.use_cassette 'init_game' do
      @game = user.games.init({ 'name' => user.name,
                                'email' => user.email })
      @game.save
    end
  end

  scenario 'launch salvos by coordinates' do
    visit game_path(@game)
    within("#new_nuke") do
      fill_in 'nuke_x', with: 2
      fill_in 'nuke_y', with: 5
      click_button 'Fire!'
    end

    page.should have_content 'Missed'
  end
end
