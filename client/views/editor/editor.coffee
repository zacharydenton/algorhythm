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
    extraKeys: "Tab": "autocomplete"
  CodeMirror.commands.autocomplete = (cm) ->
    if cm.getCursor().ch == 0
      spaces = Array(cm.getOption("indentUnit") + 1).join(" ")
      cm.replaceSelection(spaces, "end", "+input")
    else
      CodeMirror.showHint cm, CodeMirror.coffeescriptHint
  CodeMirror @find('#editor'), opts
