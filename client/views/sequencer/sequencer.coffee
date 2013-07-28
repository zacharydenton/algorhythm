@Algo ?= {}

class Sequencer
  constructor: (@$el, @minNote, @maxNote) ->
    @buildKeyboard()
    @buildGrid()
    @pixelsPerSecond = 200
    @notes = []

  buildKeyboard: ->
    @$keyboard = $('<ul>')
    @$keyboard.addClass 'keyboard'
  
    _.each [@maxNote..@minNote], (note) => # A0 to C8
      $key = $('<li>')
      if Algo.isAccidental(note)
        $key.addClass 'accidental'

      @$keyboard.append $key
      
      unless Algo.isAccidental(note)
        $spacer = $('<li>')
        $spacer.addClass 'spacer'
        @$keyboard.append $spacer
  
    @$el.append @$keyboard
    @$keyboard

  buildGrid: ->
    @$grid = $('<div>')
    @$grid.addClass 'note-grid'
    @$grid.height @$keyboard.height()
    @$el.append @$grid
    @$grid

  insert: (note, start, duration) ->
    $note = $('<span>')
    noteObj =
      note: note
      start: start * Algo.metronome.spb()
      duration: duration * Algo.metronome.spb()
      $el: $note
    $note.addClass 'note'
    offset = (@maxNote - note - 0.5) * (@$keyboard.height() / (@maxNote - @minNote))
    $note.css 'top', offset
    $note.css 'left', @pixelsPerSecond * noteObj.start
    $note.css 'width', @pixelsPerSecond * noteObj.duration
    @$grid.append $note
    @notes.push noteObj
    noteObj

  play: ->
    time = Algo.audioContext.currentTime
    for note in @notes
      Algo.instrument.noteOn note.note, time + note.start
      Algo.instrument.noteOff note.note, time + note.start + note.duration

Template.sequencer.rendered = ->
  Algo.sequencer = new Sequencer $('#piano-roll'), 31, 88
