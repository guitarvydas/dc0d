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
    zd.append_leaf (leaves, std.string_constant ("go home;continue"))
    zd.append_leaf (leaves, std.string_constant ("fight;flee"))
    zd.append_leaf (leaves, std.string_constant ("adventure;rest;shop;quit"))
}

int2string :: proc (i : int) -> string {
    return fmt.aprintf ("%d", i)
}

///

shop_menu := [2 * 2]string{
    "_", "leave",
    "buy", "buy",
}

Format_Shop_Instance_Data :: struct {
    s : string,
    latchmap : ^map[string]^zd.Message
}

fetch_latched_bool :: proc (inst : ^Shop_Menu_Instance_Data, port_name : string) -> bool {
    saved_msg := inst.latchmap [port_name]
    return saved_msg.data.(bool)
}

latch :: proc (inst :  ^Shop_Menu_Instance_Data, msg : ^zd.Message) {
    inst.latchmap [msg.port] = msg
}

    
Format_Shop_Choice :: proc (name: string, owner : ^zd.Eh) -> ^zd.Eh {
    handle :: proc (eh: ^zd.Eh, msg: ^zd.Message) {
	switch msg.port {
	case "buy?":
	    inst := &eh.instance_data.(Shop_Menu_Instance_Data)
	    latch (inst, msg)
	case "ask":
	    // build result string, then send it to port "", something like: ";leave;buy"
	    // remember to free intermediate strings
	    // surely, this can be written to be more "efficient", but, first one must ask what is the ROI of doing that? Does the expense of rewriting this
	    // come out to drop the price of the final product? What if I change my mind and throw this code away and do something different? Is it worth
	    // my time to optimize this now or to wait until production engineering? I vote for: do the most straight-foward thing for now, no matter how
	    // stupid-looking, then prove that it is worth the expense to write it "more efficiently"
	    for i := 0 ; i < len (inst.menu) ; i += 2 {
		guard := inst.menu [i]
		if guard == "_" || true == fetch_latched_bool (inst, guard) {
		    v := inst.menu [i+1]
		    stemp := inst.s
		    inst.s := fmt.aprintf ("%v;%v", stemp, v);
		    delete (stemp)
		    
		}
		zd.send (eh, "", s)
		stemp := s
		s := ""
		delete (stemp)
	    case:
		fmt.assertf (false, "fatal internal error in shop formatting")
	    }
	}
    }
    
    name_with_id := gensym("stringconcat")
    instp := new (Format_Shop_Instance_Data)
    instp.s = ""
    instp.latchmap = new(map[string]^zd.Message)
    return zd.make_leaf (name_with_id, owner, instp^, handle)
}
///




Port_String_Pair :: struct {
    port: string,
    s : string,
}

Demux4_Instance_Data :: struct {
    menu : [4]Port_String_Pair
}

parse_menu :: proc (eh : ^zd.Eh, inst: ^Demux4_Instance_Data, msg: ^zd.Message) {
    s := msg.repr (msg)
    for i := 1; i <= 4; i+= 1 {
	inst.port [i-1] = fmt.aprintf ("%d", i)
    }
    ???
}

demux4 :: proc (name: string, owner : ^zd.Eh) -> ^zd.Eh {
    handle :: proc (eh: ^zd.Eh, msg: ^zd.Message) {
	// two inputs
	// menu: a string of up to 4 items separated by ";" (no ";" required at end), e.g. "adventure;rest;shop;quit" and "fight;flee"
	// choice: a string containing an int, origin 1, representing which menu item to select
	//
	// output: 4 outputs 1-4, selected menu item sent as string on corresponding output, e.g.
	//   "1" : "adventure"
	//   "2" : "rest"
	//   "3" : "shop"
	//   "4" : "quit"
	inst := &eh.instance_data.(Demux4_Instance_Data)
	switch msg.port {
	case "menu":
	    parse_menu (eh, inst, msg)
	case "choice":
	    answer : Datum
	    m := zd.make_message(answer.port, answer.s, zd.make_cause (main_container, nil) )
	    zd.send_string (eh, ???, m, msg)
        case:    
            fmt.assertf (false, "bad msg.port for demux4: %v\n", msg.port)
	}    
    }
    name_with_id := gensym("stringconcat")
    instp := new (StringConcat_Instance_Data)
    instp.count = 0
    return zd.make_leaf (name_with_id, owner, instp^, handle)
}
