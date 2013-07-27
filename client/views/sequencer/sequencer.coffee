buildKeyboard = ->
  $keyboard = $('<ul>')
  $keyboard.addClass 'keyboard'

  _.each [21..108], (note) -> # A0 to C8
    $key = $('<li>')
    if Algo.isAccidental(note)
      $key.addClass 'accidental'
    $keyboard.append $key

  $keyboard

Template.sequencer.rendered = ->
  $('#piano-roll').append buildKeyboard()
