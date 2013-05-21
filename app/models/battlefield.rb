class Battlefield
  attr_reader :cells, :cell_size

  def initialize(cells: 10, cell_size: 20)
    @cells = cells
    @cell_size = cell_size
    @half_cell_size = cell_size / 2
  end

  def field_size
    (cells + 1) * cell_size
  end
  alias :width :field_size
  alias :height :field_size

  def cell_width
    cell_size - 1
  end

  def cell_height
    cell_width
  end

  def ox_label_x(x)
    x * cell_size + @half_cell_size
  end

  def ox_label_y
    -5
  end

  def oy_label_dx
    -10
  end

  def oy_label_dy(y)
    y * cell_size + cell_size - 5
  end

  def translate_ox(x)
    x * cell_size + 3
  end

  def cell_y(y)
    y * cell_size + 2
  end

  def cell_state(game, x, y)

  end
end
