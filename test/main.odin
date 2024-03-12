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

