package dc0d

even :: proc (n : int) {
    if 0 == n / 2 {
	return true
    } else {
	return false
    }
}

to_port (s : string) -> Port_Type {
    return transmute(Port_Type)s
}

user_choice :: proc (eh: ^zd.Eh, pairs : []string, causing_msg : ^Message) {
    assert (even (len (pair)))

    for i = 0 ; i += 2 {
	choices_list := []string
	
	guard_string := pairs [i]
	choice := pairs [i + 1]
	out_port := to_port (choice)

	guard := true

	choice_number := 1
	
	if "" != guard_string {
	    guard_port := to_port (guard_string)
	    guard := zd.inp (eh, guard_port)
	}

	if guard {
	    append (choices_list, fmt.aprintf ("%v: %v\n", choice_number, choice))
	    choice_number += 1
	}
    }
  
    
    assert (choice_number >= 1)
    
    choice := ask_choice (eh, choices_list, choice_number - 1)
    
    chosen_string := choices_list [choice]
    chosen_port := to_port (chosen_string)
    
    zd.send (eh, chosen_port, new_datum_bang (), causing_msg)
}

ask_choice :: proc (eh : ^zd.Eh, choices : []string, max : int) -> int{
    assert (max >= 1) // max is 1-based, expect max to be 1..N
    result := -1
    while result < max {
	fmt.printf ("pick a number:\n%v", choices)
	result := to_int (getc ())
	if result < max {
	    fmt.printf ("%d is an invalid choice, pick again (input must be between 1 and %v)\n", result, max)
	}
    }
    ???
    
