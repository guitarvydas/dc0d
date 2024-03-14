package project

import "core:fmt"
import "core:os"

import zd "../0d/odin"
import "../0d/odin/std"

main :: proc() {
    arg, main_container_name, diagram_names := std.parse_command_line_args ()
    palette := std.initialize_component_palette (diagram_names, components_to_include_in_project)
    std.run (&palette, arg, main_container_name, diagram_names, start_function)
}

start_function :: proc (arg: string, main_container : ^zd.Eh) {
    arg := zd.new_datum_string (arg)
    msg := zd.make_message("", arg, zd.make_cause (main_container, nil) )
    main_container.handler(main_container, msg)
}


components_to_include_in_project :: proc (leaves: ^[dynamic]zd.Leaf_Template) {
    zd.append_leaf (leaves, zd.Leaf_Template { name = "prompt", instantiate = prompt })    
    zd.append_leaf (leaves, std.string_constant ("1=adventure 2=shop 3=rest 4=quit"))

    zd.append_leaf (leaves, zd.Leaf_Template { name = "range", instantiate = range })    
    zd.append_leaf (leaves, std.string_constant ("1"))
    zd.append_leaf (leaves, std.string_constant ("4"))
    zd.append_leaf (leaves, std.string_constant ("2")) // test value
    zd.append_leaf (leaves, std.string_constant ("5")) // test value
    zd.append_leaf (leaves, std.string_constant ("0")) // test value

    zd.append_leaf (leaves, zd.Leaf_Template { name = "Demux 4", instantiate = demux4 })

    zd.append_leaf (leaves, std.string_constant ("in range"))
    zd.append_leaf (leaves, std.string_constant ("out of range"))

}

prompt :: proc (name : string, owner : ^zd.Eh) -> ^zd.Eh {
    handle :: proc (eh: ^zd.Eh, msg: ^zd.Message) {
	menu :=  msg.datum.repr (msg.datum) // msg must contain a prompt string
	fmt.println (menu)
	buff : [16]u8
	n, err := os.read (os.stdin, buff[:])
	if err != os.ERROR_NONE || n < 1 {
	    zd.send_string (eh, "✗", fmt.aprintf ("ERROR (internal) in prompt %v %v", n, err), msg)
	} else {
	    s := fmt.aprintf ("%c", buff [0])
	    zd.send_string (eh, "", s, msg)
	    delete (s)
	}
    }
    name_with_id := std.gensym("shell_out")
    return zd.make_leaf (name_with_id, owner, nil, handle)
}

////
Range_data :: struct {
    low : int,
    high : int
}

range :: proc (name : string, owner : ^zd.Eh) -> ^zd.Eh {
    handle :: proc (eh: ^zd.Eh, msg: ^zd.Message) {
	str :=  msg.datum.repr (msg.datum)
	length := len (str)
	if 1 == length {
            inst := &eh.instance_data.(Range_data)
	    c := cast (int) str [0]
	    if c >= '0' && c <= '9' {
		switch (msg.port) {
		case "low":
		    inst.low = c
		case "high":
		    inst.high = c
		case "":
		    if c >= inst.low && c <= inst.high {
			zd.send_string (eh, "", str, msg) // in range
		    } else {
			zd.send_string (eh, "out of range", str, msg) // out of range
		    }
		case:
		    zd.send_string (eh, "✗", str, msg)
		}
	    } else {
		    zd.send_string (eh, "✗", str, msg)
	    }
	} else {
	    zd.send_string (eh, "✗", str, msg)
	}
    }
    name_with_id := std.gensym("range")
    instp := new (Range_data)
    return zd.make_leaf (name_with_id, owner, instp^, handle)
}

////

demux4 :: proc (name: string, owner : ^zd.Eh) -> ^zd.Eh {
    handle :: proc (eh: ^zd.Eh, msg: ^zd.Message) {
        // incoming datum is a string, containing a digit 1-4, pulse the corresponding output
        pulse := zd.new_datum_bang ()
        switch msg.datum.repr (msg.datum) {
        case "1":
            zd.send (eh, "1", pulse, msg)
        case "2":
            zd.send (eh, "2", pulse, msg)
        case "3":
            zd.send (eh, "3", pulse, msg)
        case "4":
            zd.send (eh, "4", pulse, msg)
        case:
            fmt.assertf (false, "fatal internal error in demux4")
        }
    }
    
    name_with_id := std.gensym("demux4")
    return zd.make_leaf (name_with_id, owner, nil, handle)
}

