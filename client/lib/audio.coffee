@Algo ?= {}

Meteor.startup ->
  Algo.audioContext = new webkitAudioContext()
  Algo.metronome = new Algo.Metronome()

  finalMixNode = Algo.audioContext.destination
  Algo.masterGainNode = Algo.audioContext.createGainNode() # master volume
  Algo.masterGainNode.gain.value = 0.7 # reduce overall volume to avoid clipping
  Algo.masterGainNode.connect finalMixNode

  Algo.instrument = new Algo.Instrument "/soundbanks/classical/p", 52, 89
  Algo.instrument.connect Algo.masterGainNode

Algo.noteOn = (note, time) ->
  time ?= Algo.audioContext.currentTime
  midi = note.key() + 20
  Algo.instrument.noteOn midi, time

Algo.noteOff = (note, time) ->
  time ?= Algo.audioContext.currentTime
  midi = note.key() + 20
  Algo.instrument.noteOff midi, time

Algo.strum = (notes, startTime, speed) ->
  startTime ?= Algo.audioContext.currentTime
  speed ?= 0.05
  start = startTime
  for note in notes
    Algo.noteOn note, start
    start += speed
