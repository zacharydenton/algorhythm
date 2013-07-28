@Algo ?= {}

class Algo.Metronome
  constructor: ->
    @beatCount = 0
    @lastBeat = Algo.audioContext.currentTime
    unless Session.get('bpm')?
      Session.set 'bpm', 120

  bpm: ->
    Session.get 'bpm'

  bps: ->
    @bpm() / 60

  spb: ->
    1 / @bps()

  beat: (offset) ->
    @updateLast()
    @lastBeat + offset * @spb()

  measure: (offset) ->
    @updateLast()
    beatsSinceLast = @beatCount % 4
    lastMeasure = @lastBeat - (beatsSinceLast * @spb())
    lastMeasure + offset * (4 * @spb())

  updateLast: ->
    while Algo.audioContext.currentTime - @lastBeat > @spb()
      @beatCount += 1
      @lastBeat += @spb()

Algo.range = (minNote, maxNote) ->
  result = []
  min = minNote.key()
  max = maxNote.key()
  for key in [min..max]
    result.push Algo.note.fromKey(key)
  return result

Algo.choose = (array) ->
  array[_.random(array.length - 1)]

Meteor.startup ->
  Algo.note = teoria.note
  Algo.chord = teoria.chord
  Algo.scale = teoria.scale
