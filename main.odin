package dc0d

import "core:fmt"

import zd "0d/odin"
import "0d/odin/std"

max_recharge := 10
damage_sword := 4
cost_sword := 10

Player :: struct {
    ok : int,
    wallet : int,
    pwr : int,
}

Monster :: struct {
    ok : int,
    wallet : int,
    pwr : int,
}

p := new (Player)
m := new (Monster)
ndays := 0

main :: proc() {
    //context.logger = std.log (zd.log_light_handlers) // see ../../0d/odin/std/lib.odin for other options
    arg, main_container_name, diagram_names := std.parse_command_line_args ()
    palette := std.initialize_component_palette (diagram_names, components_to_include_in_project)
    //zd.dump_registry (palette)
    std.run_all_outputs (&palette, arg, main_container_name, diagram_names, start_function)
}

start_function :: proc (arg: string, main_container : ^zd.Eh) {
    x := zd.new_datum_string (arg)
    msg := zd.make_message("", x, zd.make_cause (main_container, nil) )
    main_container.handler(main_container, msg)
}


next :: proc (eh: ^zd.Eh, msg: ^zd.Message) {
    zd.send(eh=eh, port="", datum=zd.new_datum_bang (), causingMessage=msg)
}

components_to_include_in_project :: proc (leaves: ^[dynamic]zd.Leaf_Template) {
    generated_components_to_include_in_project (leaves)
    zd.append_leaf (leaves, zd.Leaf_Template { name = "Game Choice", instantiate = Game_Choice })
    zd.append_leaf (leaves, zd.Leaf_Template { name = "Shop Choice", instantiate = Shop_Choice })
    zd.append_leaf (leaves, zd.Leaf_Template { name = "Fight Choice", instantiate = Fight_Choice })
    zd.append_leaf (leaves, zd.Leaf_Template { name = "Win Choice", instantiate = Win_Choice })
    zd.append_leaf (leaves, zd.Leaf_Template { name = "Die Choice", instantiate = Die_Choice })
    zd.append_leaf (leaves, zd.Leaf_Template { name = "Demux 4", instantiate = demux4 })
}

int2string :: proc (i : int) -> string {
    return fmt.aprintf ("%d", i)
}

///

///

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
    
    name_with_id := std.gensym("Win_Choice")
    return zd.make_leaf (name_with_id, owner, nil, handle)
}


