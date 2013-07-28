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

Algo.register 'chaos', 1, 100, 62
Algo.register 'density'
Algo.register 'minNote', 31, 88, 60
Algo.register 'maxNote', 31, 88, 71

prev = null

Algo.update = ->
  chaos = 0.01 * Algo.get 'chaos'
  density = 0.01 * Algo.get 'density'
  min = Algo.note.fromMIDI(Algo.get 'minNote')
  max = Algo.note.fromMIDI(Algo.get 'maxNote')
  
  if Math.random() > density
    return
    
  if prev? and Math.random() > chaos
    root = Algo.choose prev.enharmonics()
  else
    root = Algo.choose Algo.range(min, max)
    
  for note in root.chord('major').notes()
    duration = Algo.choose [1..4]
    Algo.sequencer.insert note, duration
    
Algo.sequencer.play()
"""
