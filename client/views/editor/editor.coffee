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
  CodeMirror @find('#editor'), opts
