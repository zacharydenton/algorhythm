@Algo ?= {}

class Algo.Instrument
  constructor: (baseUrl, @minNote, @maxNote) ->
    @output = Algo.audioContext.createGainNode()
    @buffers = []
    @sources = []
    urls = ("#{baseUrl}#{note}.ogg" for note in [minNote..maxNote])
    loader = new BufferLoader Algo.audioContext, urls, (bufferList) =>
      @buffers = bufferList
    loader.load()

  noteOn: (note, time) ->
    time ?= Algo.audioContext.currentTime
    console.log "noteOn: #{note}, #{time}"
    buffer = @buffers[note - @minNote]
    source = Algo.audioContext.createBufferSource()
    source.connect @output
    source.buffer = buffer
    source.start time
    @sources[note - @minNote] = source
    return source

  noteOff: (note, time) ->
    time ?= Algo.audioContext.currentTime
    console.log "noteOff: #{note}, #{time}"
    @sources[note - @minNote].stop time

  connect: (target) ->
    @output.connect target
