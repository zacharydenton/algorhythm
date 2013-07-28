@Algo ?= {}

class Sample
  constructor: (buffer) ->
    @output = Algo.audioContext.createGainNode()
    @source = Algo.audioContext.createBufferSource()
    @source.buffer = buffer
    @source.connect @output

  noteOn: (time) ->
    time ?= Algo.audioContext.currentTime
    @source.start time

  noteOff: (time) ->
    time ?= Algo.audioContext.currentTime
    @output.gain.exponentialRampToValueAtTime 0, time
    @source.stop time

  connect: (target) ->
    @output.connect target

class Algo.Instrument
  constructor: (baseUrl, @minNote, @maxNote) ->
    @output = Algo.audioContext.createGainNode()
    @buffers = []
    @samples = []
    urls = ("#{baseUrl}#{note}.ogg" for note in [minNote..maxNote])
    loader = new BufferLoader Algo.audioContext, urls, (bufferList) =>
      @buffers = bufferList
    loader.load()

  noteOn: (note, time) ->
    time ?= Algo.audioContext.currentTime
    buffer = @buffers[note - @minNote]
    return unless buffer?
    sample = new Sample(buffer)
    sample.connect @output
    @samples[note] = sample
    sample.noteOn time
    return sample

  noteOff: (note, time) ->
    time ?= Algo.audioContext.currentTime
    sample = @samples[note]
    return unless sample?
    sample.noteOff time

  connect: (target) ->
    @output.connect target
