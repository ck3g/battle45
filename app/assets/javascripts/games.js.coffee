# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
  $nuke_x = $("#nuke_x")
  $nuke_y = $("#nuke_y")

  $('.cell').on 'click', ->
    $cell = $(this)
    $selected = $(".selected")

    # jQuery doesnt understand how to removeClass() for <rect>
    if $selected.length
      clean_class = $selected.attr('class').replace ' selected', ''
      $selected.attr('class', clean_class)

    # jQuery doesnt understand how to addClass() for <rect>
    $cell.attr('class', "#{ $cell.attr('class') } selected")

    $nuke_x.val $cell.data('x')
    $nuke_y.val $cell.data('y')

