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
      "Ctrl-Enter": "evalSelection"
      "Ctrl-Alt-Enter": "evalAll"
  CodeMirror.commands.autocomplete = autocomplete
  CodeMirror.commands.evalAll = (cm) ->
    Algo.eval cm.getValue()
  CodeMirror.commands.evalSelection = (cm) ->
    Algo.eval cm.getSelection()
  editor = CodeMirror @find('#editor'), opts
  editor.setValue """
# Press ctrl-alt-enter to execute code

for measure in [0..30]
  for note in (n for n in [60..72] when Math.random() < 0.318 and not Algo.isAccidental(n))
    dur1 = Algo.choose [0, 1/2]
    dur2 = Algo.choose [1, 2, 4, 8]
    Algo.sequencer.insert note, measure + dur1, dur2

Algo.sequencer.play()
"""
