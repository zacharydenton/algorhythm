@Algo ?= {}

class Sequencer
  constructor: (@$el, @minNote, @maxNote) ->
    @buildKeyboard()
    @buildGrid()
    @pixelsPerSecond = 200
    @current = 0
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

  insert: (note, duration, start) ->
    start ?= @current
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
    @notes[start] ?= []
    @notes[start].push noteObj
    noteObj

  play: ->
    @current = 0
    @noteTime = 0.0
    @startTime = Algo.audioContext.currentTime
    @schedule()

  stop: ->
    return unless @ticker?
    Meteor.clearTimeout @ticker

  clear: ->
    @notes = []
    @$grid.empty()

  schedule: =>
    currentTime = Algo.audioContext.currentTime
    currentTime -= @startTime # normalize to 0

    while @noteTime < currentTime + 0.040
      if @notes[@current]?
        for note in @notes[@current]
          contextPlayTime = note.start + @startTime
          Algo.instrument.noteOn note.note, contextPlayTime
          Algo.instrument.noteOff note.note, contextPlayTime + note.duration

      @advanceBeat()

    @ticker = Meteor.setTimeout @schedule, 0

  advanceBeat: ->
    @current += 1
    @noteTime += Algo.metronome.spb()
    if Algo.update?
      Algo.update()

Template.sequencer.rendered = ->
  Algo.sequencer = new Sequencer $('#piano-roll'), 31, 88
