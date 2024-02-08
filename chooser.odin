package dc0d

import "core:fmt"

import zd "0d/odin"
import "0d/odin/std"


ChoiceMenu : []string

user_choice (eh: ^Eh, msg : ^zd.Message, choice_pairs : ChoiceMenu) {
    choices := [dynamic]string{} // initialize set of choices to be an empty array 
    defer delete (choices)
    construct_choices (eh, choice_pairs[:], &choices)
    //
    // present the menu and ensure that a valid choice is made
    index := -1
    while (index < 0) or (index > len (choice) - 1) {
	display_menu (choices)
	index = getint ()
    }
    zd.send (eh, choices [index], datum_new_bang (), msg)
}

construct_choices (eh: ^zd.Eh, choice_pairs : ChoiceMenu, choices: ^[dynamic]string) {
    // create an array of choice strings
    // each pair is the name of a guard port (input port (bool) or ""), and a string which contains the question (and doubles as the output port name)
    // the question - a menu item - is appended to the choice string array only if the guard port is true    
    if len (choice_pairs) > 0 {
	include := true
	guard_port := choice_pairs [0]
	ask_string := choice_pairs [1]
	if guard_port != "" {
	    include = cast(bool) (zd.inp (eh, guard_port).raw ()) // fetch value of the named port
	}
	if include {
	    append (&choices, ask_string)
	}
	construct_choices (choice_pairs [2:], choices)
    }
}

display_menu (choices : ^[dynamic]string) {
    fmt.printf ("make a choice: %v\n", choices) // TODO: make this less stupid
}

getint :: proc () -> int{
    c : [1]byte
    n, err := os.read (os.stdin, buffer[:])
    if !err and n = 1 {
	return atoi (buffer [0])
    } else {
	return -1
    }
}
