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
    zd.append_leaf (leaves, std.string_constant ("go home;continue"))
    zd.append_leaf (leaves, std.string_constant ("fight;flee"))
    zd.append_leaf (leaves, std.string_constant ("adventure;rest;shop;quit"))
}

int2string :: proc (i : int) -> string {
    return fmt.aprintf ("%d", i)
}

///

Latched_Messages :: [map]^zd.Message
Menu_Strings :: [2 * 4] string

fetch_latched_bool :: proc (latchedmsgs : Latched_Messages, port_name : string) -> bool {
    saved_msg := latchmessages [port_name]
    return saved_msg.data.(bool)
}

latch :: proc (inst :  ^Shop_Menu_Instance_Data, msg : ^zd.Message) {
    inst.latchmap [msg.port] = msg
}

    
send_choice :: proc (eh : ^zd.Eh, latchedmessages : Latched_Messages, menu : Menu_Strings) {
    // build result string, then send it to port "", something like: ";leave;buy"
    // remember to free intermediate strings
    // surely, this can be written to be more "efficient", but, first one must ask what is the ROI of doing that? Does the expense of rewriting this
    // come out to drop the price of the final product? What if I change my mind and throw this code away and do something different? Is it worth
    // my time to optimize this now or to wait until production engineering? I vote for: do the most straight-foward thing for now, no matter how
    // stupid-looking, then prove that it is worth the expense to write it "more efficiently"

    s := ""
    for i := 0 ; i < len (menu) ; i += 2 {
	guard := menu [i]
	if (guard != "✗" && ((guard == "✓") || (true == fetch_latched_bool (latchedmessages, guard)))) {
	    v := menu [i+1]
	    stemp := s
	    s := fmt.aprintf ("%v;%v", stemp, v)
	    delete (stemp)
	}
    }
    zd.send (eh, "", s)
    delete (s)
}



shop_menu := Menu_Strings{
    "✓",   "leave",
    "buy", "buy",
    "✗",   "",
    "✗",   "",
}

Shop_Instance_Data :: struct {
    latchmap : ^map[string]^zd.Message
}

Shop_Choice :: proc (name: string, owner : ^zd.Eh) -> ^zd.Eh {
    handle :: proc (eh: ^zd.Eh, msg: ^zd.Message) {
	inst := &eh.instance_data.(Shop_Instance_Data)
	switch msg.port {
	case "buy?":
	    latch (inst, msg)
	case "ask":
	    send_choice (eh, inst.latchmap, shop_menu) 
        case:
	    fmt.assertf (false, "fatal internal error in Shop_Choice")
	}
    }
    
    name_with_id := gensym("Shop_Choice")
    instp := new (Shop_Instance_Data)
    instp.latchmap = new(map[string]^zd.Message)
    return zd.make_leaf (name_with_id, owner, instp^, handle)
}

game_menu := Menu_Strings{
    "✓", "adventure",
    "✓", "rest",
    "✓", "shop",
    "✓", "quit"
}

Game_Instance_Data :: struct {
    latchmap : ^map[string]^zd.Message
}

Game_Choice :: proc (name: string, owner : ^zd.Eh) -> ^zd.Eh {
    handle :: proc (eh: ^zd.Eh, msg: ^zd.Message) {
	inst := &eh.instance_data.(Game_Instance_Data)
	switch msg.port {
	case "ask":
	    send_choice (eh, inst.latchmap, game_menu) 
        case:
	    fmt.assertf (false, "fatal internal error in Game_Choice")
	}
    }
    
    name_with_id := gensym("Game_Choice")
    instp := new (Game_Instance_Data)
    instp.latchmap = new(map[string]^zd.Message)
    return zd.make_leaf (name_with_id, owner, instp^, handle)
}

fight_menu := Menu_Strings{
    "✓", "fight",
    "✓", "flee",
    "✗", "",
    "✗", ""
}

Fight_Instance_Data :: struct {
    latchmap : ^map[string]^zd.Message
}

Fight_Choice :: proc (name: string, owner : ^zd.Eh) -> ^zd.Eh {
    handle :: proc (eh: ^zd.Eh, msg: ^zd.Message) {
	inst := &eh.instance_data.(Fight_Instance_Data)
	switch msg.port {
	case "ask":
	    send_choice (eh, inst.latchmap, fight_menu) 
        case:
	    fmt.assertf (false, "fatal internal error in Fight_Choice")
	}
    }
    
    name_with_id := gensym("Fight_Choice")
    instp := new (Fight_Instance_Data)
    instp.latchmap = new(map[string]^zd.Message)
    return zd.make_leaf (name_with_id, owner, instp^, handle)
}

die_menu := Menu_Strings{
    "✓", "quit",
    "✓", "restart",
    "✗", "",
    "✗", ""
}

Die_Instance_Data :: struct {
    latchmap : ^map[string]^zd.Message
}

Die_Choice :: proc (name: string, owner : ^zd.Eh) -> ^zd.Eh {
    handle :: proc (eh: ^zd.Eh, msg: ^zd.Message) {
	inst := &eh.instance_data.(Die_Instance_Data)
	switch msg.port {
	case "ask":
	    send_choice (eh, inst.latchmap, die_menu) 
        case:
	    fmt.assertf (false, "fatal internal error in Die_Choice")
	}
    }
    
    name_with_id := gensym("Die_Choice")
    instp := new (Die_Instance_Data)
    instp.latchmap = new(map[string]^zd.Message)
    return zd.make_leaf (name_with_id, owner, instp^, handle)
}

///


