workflow:
1. build REPL using Odin compiler
2. run REPL
3. load diagrams
4. build dc0d
5. run !

API:
  das2json ("filename")
  load ("filename")
  set_focus ("component name")
  build ("component name")
  prompt_for_value ("port name")
  inject ("port name", "value string")
  display_palette ()
  set_trace_none ()
  set_trace_all ()
  set_trace_minimum ()
  set_trace_medium ()
  reset_repl ()
  print_specific_output ("port name")
  print_all_outputs ()

Registers:
`focus` -- string containing name of current component (e.g. top level component)
`display` -- int ; 0 means no tracing, 1 means minimum tracing, 2 means medium tracing, 100 means trace all
`palette` -- `Component_Registry` containing map of all components

Commands: j, l, f, b, i, r, d, o, z, p

`> j filename` -- compile filename diagram to JSON leaving it in the current directory, and load the JSON
`> l filename` -- load the filename, assuming it to be a JSON-ified diagram, overwrite previous components with same names (or, make them inaccessible)
`> f component name` -- set `focus` to component name (name may include spaces)
`> b` -- build component which is in `focus` register
`> b component name` -- set `focus` to component name, then build it
`> i port name` -- causes prompt for value string
`    value string` -- send value to input "port name" of `focus` component (name and value may contain spaces)
`> r` -- run component stored in `focus`, but don't send any inputs to it
`> r component name` -- set `focus` to be component name, then run
`> d` -- list palette dictionary contents
`> o *` -- set runtime display all option
`> o 1` -- set runtime display option to `mininum`
`> o 2` -- set runtime display option to `medium`
`> o 0` -- clear all runtime display options
`> z` -- reset REPL, free all templates, clear REPL registers
`> p port name` -- print oldest value in output `port name` of component in `focus`
`> p *` -- print all outputs of component in `focus`

---

I'm lazy, so I'll ask before looking it up myself: How do I get input from the user console in Odin?

I want to prompt for a line, buffering everything the user types until a RETURN is typed.

The line consists of
1. a `command`
2. `everything else`.

A `command` is a string: the first group of non-whitespace characters in the line. The `command` may not contain any whitespace.

`Everything else` is a string: the stuff on the line following the command, stripped (no whitespace at front or tail). This stuff might contain whitespace (but not newlines).


---


1. hard-code the leaf components in the underlying language - in this case Odin
   - use a code generator if possible, instead of writing the code by hand
   - the standard 0D library contains implementations, in Odin, of a set of baseline components
   - project-specific components can be gleaned from the project diagram and converted to Odin code
2. compile the 0D interpreter including the hard-coded leaves, using the Odin compiler
3. generate JSON for the project diagram - das2json tool
4. run the 0D interpreter
   - LOAD project diagram json
   - LOAD std0d - standard 0D library - diagram json
	 - LOADing a diagram means to create templates for all components on a diagram in some sort of internal dictionary
	 - overwrite any existing components with the same name (or, make previous versions inaccessible)
   - INSTANTIATE the project, given the name of the top-level component
   - grab command-line arguments and put them somewhere accessible to the project components
   - EXEC the instantiated project by `send()`ing argv[1] to the `""` input port of the top-level component
	 - `""` is the no-name input port, essentially `stdin`
   
0D REPL:
> load diagram-filename -- overwrite components that have already been defined
> load std0d-filename
> build `xyz` -- instantiate component `xyz` and put `xyz` in the focus slot
> run `arg`

options, if desired, that must be enabled before `run` is executed:
> list - [display dictionary contents]
> all - [set internal option to display all sends & receives in full glory as routing proceeds]
> min - [set internal option to display the name of each component that is activated]
> med - [set internal option to display the name of each component and the incoming message as routing proceeds]

after `run`:
> p "..." find the "..." output port of the top level component, display the first (in time) output in that queue
> p all

overwrite
das2json diagram

Thinking out loud...

I think that I want to build a REPL for odin 0D. Kibitzing appreciated.

Here is my thinking thus far. Subject to change...

REPL registers (global to all REPL commands, static)
`focus` -- string containing name of current component (e.g. top level component)
`display` -- int ; 0 means no tracing, 1 means minimum tracing, 2 means medium tracing, 100 means trace all
`palette` -- `Component_Registry` containing map of all components

REPL commands:
`> j filename` -- compile filename diagram to JSON leaving it in the current directory, and load the JSON
`> l filename` -- load the filename, assuming it to be a JSON-ified diagram, overwrite previous components with same names (or, make them inaccessible)
`> f component name` -- set `focus` to component name (name may include spaces)
`> b` -- build component which is in `focus` register
`> b component name` -- set `focus` to component name, then build it
`> i port name` -- causes prompt for value string
`    value string` -- send value to input "port name" of `focus` component (name and value may contain spaces)
`> r` -- run component stored in `focus`, but don't send any inputs to it
`> r component name` -- set `focus` to be component name, then run
`> d` -- list palette dictionary contents
`> o *` -- set runtime display all option
`> o 1` -- set runtime display option to `mininum`
`> o 2` -- set runtime display option to `medium`
`> o 0` -- clear all runtime display options
`> z` -- reset REPL, free all templates, clear REPL registers
`> p port name` -- print oldest value in output `port name` of component in `focus`
`> p *` -- print all outputs of component in `focus`

REPL API:
```
  das2json ("filename")
  load ("filename")
  set_focus ("component name")
  build ("component name")
  prompt_for_value ("port name")
  input ("port name", "value string")
  run ()
  display_palette ()
  set_runtime_display_all ()
  set_runtime_display_minimum ()
  set_runtime_display_medium ()
  reset_repl ()
  print_specific_output ("port name")
  print_all_outputs ()
```

  
