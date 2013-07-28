autocomplete = (cm) ->
  if cm.getCursor().ch == 0
    spaces = Array(cm.getOption("indentUnit") + 1).join(" ")
    cm.replaceSelection(spaces, "end", "+input")
  else
    CodeMirror.showHint cm, CodeMirror.coffeescriptHint

Template.editor.rendered = ->
  opts =
    theme: 'ambiance'
    mode: 'coffeescript'
    indentUnit: 2
    smartIndent: on
    tabSize: 2
    indentWithTabs: off
    electricChars: on
    lineNumbers: on
    autofocus: on
    extraKeys:
      "Tab": "autocomplete"
      "Ctrl-Enter": "evalLine"
      "Shift-Enter": "evalSelection"
      "Ctrl-Alt-Enter": "evalAll"
  CodeMirror.commands.autocomplete = autocomplete
  CodeMirror.commands.evalAll = (cm) ->
    Algo.eval cm.getValue()
  CodeMirror.commands.evalSelection = (cm) ->
    Algo.eval cm.getSelection()
  CodeMirror.commands.evalLine = (cm) ->
    Algo.eval cm.getLine(cm.getCursor().line)
  editor = CodeMirror @find('#editor'), opts
  editor.setValue """
# Press ctrl-alt-enter to evaluate code
# Press ctrl-enter to eval current line
# Press shift-enter to eval selection

Algo.register 'duration'
Algo.register 'minNote', 31, 88, 60
Algo.register 'maxNote', 31, 88, 72
Algo.register 'chaos', 1, 100, 22

Algo.generate = ->
  duration = Algo.get 'duration'
  min = Algo.get 'minNote'
  max = Algo.get 'maxNote'
  chaos = 0.01 * Algo.get 'chaos'

  Algo.sequencer.clear()
  for measure in [0..duration]
    for note in (n for n in [min..max] when Math.random() < chaos and not Algo.isAccidental(n))
      dur1 = Algo.choose [0, 1, 2]
      dur2 = Algo.choose [1, 2, 4, 8]
      Algo.sequencer.insert note, measure + dur1, dur2

Algo.generate() and Algo.sequencer.play()
"""
