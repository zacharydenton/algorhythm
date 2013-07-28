Compose music with algorithms, in your web browser.

## Introduction

When you first load the app, you'll see a script on the left
and a piano roll (sequencer) on the right. With the code editor
focused, press `ctrl-alt-enter` and the contents of the editor
will be evaluated. You'll start to see and hear notes being
generated in the sequencer. This is algorithmic composition.

## Coding compositions

In Algorhythm, the default way of writing compositions is to
define the `Algo.update` function. This function is called
every time the sequencer steps forward. In this function,
you'll typically want to insert notes via `Algo.sequencer.insert`.
For example, you might have a stochastic automaton generating
the main melody and a deterministic automaton harmonizing with
the main melody to produce the bassline. Once you have these automata,
just call them in order in the `Algo.update` function.

However, if you want to do things differently, Algorhythm provides
full access to the surrounding Javascript environment. If there's
some functionality you think Algorhythm should provide by default,
please open an issue.

## Contributing

To get algorhythm running on your local machine, first install meteorite,
then run `mrt` in the root of the repository:

```bash
$ sudo npm install -g meteorite
$ mrt
```
