module GamesHelper
  def link_to_recent_game(game)
    link_to("#{ game.user_name } [#{ t("game.statuses.#{ game.status }") }]",
            game_path(game))
  end

  def cell(game, bf, x, y)
    content_tag(
      :rect,
      '',
      width: bf.cell_width,
      height: bf.cell_height,
      y: bf.cell_y(y),
      :class => "cell #{ bf.cell_state(game, x, y) }",
      data: { x: x, y: y }
    )
  end

  def horizontal_label(bf, x)
    content_tag :text, x, x: bf.ox_label_x(x), y: bf.ox_label_y
  end

  def vertical_label(bf, y)
    content_tag :text, y, dx: bf.oy_label_dx, dy: bf.oy_label_dy(y)
  end
end
