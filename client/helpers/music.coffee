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

noteNames = ["C", "Db", "D", "Eb", "E", "F", "Gb", "G", "Ab", "A", "Bb", "B"]

Algo.name = (note) ->
  "#{noteNames[note % 12]}#{Algo.octave note}"

Algo.note = (name) ->
  if name.length == 3
    letter = name.slice(0, -1)
    octave = parseInt name[2]
  else
    letter = name[0]
    octave = parseInt name[1]
  index = _.indexOf noteNames, letter
  (12 * (octave + 1)) + index

Algo.octave = (note) ->
  Math.floor(note / 12) - 1

Algo.isAccidental = (note) ->
  Algo.name(note).length == 3

Algo.choose = (array) ->
  array[_.random(array.length - 1)]
