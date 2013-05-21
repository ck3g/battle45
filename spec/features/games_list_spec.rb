require 'spec_helper'

feature 'Games list' do
  given!(:jack) do
    create :user, name: 'Jack', email: 'jack-the-sparrow@example.com'
  end
  given!(:started_game) { create :game, user: jack }
  given!(:defeated_game) { create :defeated_game, user: jack }

  scenario 'user be able to see games list' do
    visit '/'
    within '#games' do
      within 'h2' do
        expect(page).to have_content 'Recent games'
      end
      expect(page).to have_content 'Jack [started]'
      expect(page).to have_content 'Jack [defeat]'
    end
  end

  scenario 'user can navigate to chosen game' do
    visit '/'
    within '#games' do
      click_link 'Jack [started]'
    end

    expect(current_path).to eq game_path(started_game)
  end
end
