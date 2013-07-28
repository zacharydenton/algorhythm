@Algo ?= {}

class Algo.Param
  constructor: (@$container, @label, @min=1, @max=100, @value=50, @step=1) ->
    @buildKnob()

  buildKnob: ->
    height = @$container.height()
    @$knob = $("<input type='text'>")
    @$knob.addClass 'knob'
    @$container.append @$knob
    @$knob.val @value
    @$knob.knob
      min: @min
      max: @max
      step: @step
      width: height
      height: height
      angleArc: 300
      angleOffset: -150
      bgColor: "#202020"
      fgColor: "#4d4d4d"
      inputColor: "#222"
      change: (v) =>
        @value = v
    @$knob

Algo.params ?= {}

Algo.register = (label, min, max, value, step) ->
  param = new Algo.Param($("#controls"), label, min, max, value, step)
  if label in Algo.params
    Algo.params[label].$knob.remove()
  Algo.params[label] = param
  param

Algo.get = (label) ->
  param = Algo.params[label]
  if param?
    param.value

Algo.clearParams = ->
  Algo.params = {}
  $("#controls").empty()
