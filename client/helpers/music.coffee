@Algo ?= {}

class Algo.Metronome
  constructor: ->
    $('[data-text-slider]').textslider()
    @beatCount = 0
    @delay = App.audioContext.createDelayNode()
    @lastBeat = App.audioContext.currentTime
    @noteLengths = 
      "1/32":   1/8
      "1/16T":  (1 / 4) * 2 / 3
      "1/32.":  (1 / 8) * 3 / 2
      "1/16":   1/4
      "1/8T":   (1 / 2) * 2 / 3
      "1/16.":  (1 / 4) * 3 / 2
      "1/8":    1 / 2
      "1/4T":   1 * 2 / 3
      "1/8.":   (1 / 2) * 3 / 2
      "1/4":    1
      "1/2T":   2 * 2 / 3
      "1/2":    2
      "1/4.":   1 * 3 / 2
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
    while App.audioContext.currentTime - @lastBeat > @spb()
      @beatCount += 1
      @lastBeat += @spb()

  updateNoteLength: (division) ->
    division ?= @noteLengths[6]
    @delay = 0.37299 / 44100.0 + 60 * division / @bpm()

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
