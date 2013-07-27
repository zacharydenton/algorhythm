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
  CodeMirror @find('#editor'), opts
