@Algo ?= {}

Meteor.startup ->
  Algo.audioContext = new webkitAudioContext()
  Algo.metronome = new Algo.Metronome()

  finalMixNode = Algo.audioContext.destination
  Algo.masterGainNode = Algo.audioContext.createGainNode() # master volume
  Algo.masterGainNode.gain.value = 0.7 # reduce overall volume to avoid clipping
  Algo.masterGainNode.connect finalMixNode

Algo.noteOn = (note, time) ->
  time ?= Algo.audioContext.currentTime
  console.log "noteOn: #{note}, #{time}"

Algo.noteOff = (note, time) ->
  time ?= Algo.audioContext.currentTime
  console.log "noteOff: #{note}, #{time}"
