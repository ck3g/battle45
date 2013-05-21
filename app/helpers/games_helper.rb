module GamesHelper
  def link_to_recent_game(game)
    link_to("#{ game.user_name } [#{ t("game.statuses.#{ game.status }") }]",
            game_path(game))
  end
end
