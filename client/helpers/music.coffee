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

Algo.toFrequency = (note) ->
  Math.pow(2, (note - 69) / 12) * 440.0

Algo.toNote = (frequency) ->
  12 * (Math.log(frequency / 440.0) / Math.log(2)) + 69

Algo.noteName = (note) ->
  noteNames = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"]
  noteNames[note % 12]

Algo.noteOctave = (note) ->
  Math.floor(note / 12) - 1

Algo.isAccidental = (note) ->
  Algo.noteName(note).length == 2
