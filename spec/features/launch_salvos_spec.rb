require 'spec_helper'

feature 'Launch salvos' do
  given!(:user) { create :user }

  background do
    VCR.use_cassette 'init_game' do
      @game = user.games.init({ 'name' => user.name,
                                'email' => user.email })
      @game.save
    end

    visit game_path(@game)
  end

  def launch_salvos
    within("#new_nuke") do
      fill_in 'nuke_x', with: 2
      fill_in 'nuke_y', with: 5
      click_button 'Fire!'
    end
  end

  scenario 'launch salvos by coordinates' do
    VCR.use_cassette 'launch_salvos' do
      Battle::Game.any_instance.stub(:status).and_return 'miss'
      launch_salvos
    end

    page.should have_content 'Missed'
  end

  scenario 'raise validation error when coordinates are blank' do
    VCR.use_cassette 'launch_salvos' do
      within('#new_nuke') do
        click_button 'Fire!'
      end
    end

    page.should have_content "can't be blank"
  end

  scenario 'deny to launch salvos when game is finished' do
    VCR.use_cassette 'launch_salvos' do
      Nuke.any_instance.stub(:status).and_return 'defeat'
      Battle::Game.any_instance.stub(:status).and_return 'defeat'
      launch_salvos

      page.should have_content "You have failed the victory"
      page.should have_content "Defeat"
      page.should_not have_selector('#new_nuke')
    end
  end
end
