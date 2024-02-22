package dc0d

import "core:fmt"

import zd "0d/odin"
import "0d/odin/std"

Latched_Messages :: map[string]^zd.Message
Menu_Strings :: [2 * 4] string

fetch_latched_bool :: proc (latchedmessages : ^Latched_Messages, port_name : string) -> bool {
    saved_msg := latchedmessages [port_name]
    return saved_msg.datum.data.(bool)
}

latch :: proc (latchmap : ^Latched_Messages, msg : ^zd.Message) {
    latchmap [msg.port] = msg
}

    
send_choice :: proc (eh : ^zd.Eh, latchedmessages : ^Latched_Messages, menu : Menu_Strings, cause : ^zd.Message) {
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
    zd.send_string (eh, "", s, cause)
    delete (s)
}



game_menu := Menu_Strings{
    "✓", "adventure",
    "✓", "rest",
    "✓", "shop",
    "✓", "quit"
}

shop_menu := Menu_Strings{
    "✓",   "leave",
    "buy", "buy",
    "✗",   "",
    "✗",   "",
}

fight_menu := Menu_Strings{
    "✓", "fight",
    "✓", "flee",
    "✗", "",
    "✗", "",
}

win_menu := Menu_Strings{
    "✓", "go home",
    "✓", "continue",
    "✗", "",
    "✗", ""
}

die_menu := Menu_Strings{
    "✓", "quit",
    "✓", "restart",
    "✗", "",
    "✗", ""
}



Game_Instance_Data :: struct {
    latchmap : Latched_Messages
}

Game_Choice :: proc (name: string, owner : ^zd.Eh) -> ^zd.Eh {
    handle :: proc (eh: ^zd.Eh, msg: ^zd.Message) {
	inst := &eh.instance_data.(Game_Instance_Data)
	switch msg.port {
	case "buy?":
	    latch (&inst.latchmap, msg)
	case "ask":
	    send_choice (eh, &inst.latchmap, game_menu, msg) 
        case:
	    fmt.assertf (false, "fatal internal error in Game_Choice")
	}
    }
    
    name_with_id := std.gensym("Game_Choice")
    instp := new (Game_Instance_Data)
    return zd.make_leaf (name_with_id, owner, instp^, handle)
}

Shop_Instance_Data :: struct {
    latchmap : Latched_Messages
}

Shop_Choice :: proc (name: string, owner : ^zd.Eh) -> ^zd.Eh {
    handle :: proc (eh: ^zd.Eh, msg: ^zd.Message) {
	inst := &eh.instance_data.(Shop_Instance_Data)
	switch msg.port {
	case "buy?":
	    latch (&inst.latchmap, msg)
	case "ask":
	    send_choice (eh, &inst.latchmap, shop_menu, msg) 
        case:
	    fmt.assertf (false, "fatal internal error in Shop_Choice")
	}
    }
    
    name_with_id := std.gensym("Shop_Choice")
    instp := new (Shop_Instance_Data)
    return zd.make_leaf (name_with_id, owner, instp^, handle)
}

Fight_Instance_Data :: struct {
    latchmap : Latched_Messages
}

Fight_Choice :: proc (name: string, owner : ^zd.Eh) -> ^zd.Eh {
    handle :: proc (eh: ^zd.Eh, msg: ^zd.Message) {
	inst := &eh.instance_data.(Fight_Instance_Data)
	switch msg.port {
	case "buy?":
	    latch (&inst.latchmap, msg)
	case "ask":
	    send_choice (eh, &inst.latchmap, fight_menu, msg) 
        case:
	    fmt.assertf (false, "fatal internal error in Fight_Choice")
	}
    }
    
    name_with_id := std.gensym("Fight_Choice")
    instp := new (Fight_Instance_Data)
    return zd.make_leaf (name_with_id, owner, instp^, handle)
}


Win_Instance_Data :: struct {
    latchmap : Latched_Messages
}

Win_Choice :: proc (name: string, owner : ^zd.Eh) -> ^zd.Eh {
    handle :: proc (eh: ^zd.Eh, msg: ^zd.Message) {
	inst := &eh.instance_data.(Win_Instance_Data)
	switch msg.port {
	case "buy?":
	    latch (&inst.latchmap, msg)
	case "ask":
	    send_choice (eh, &inst.latchmap, win_menu, msg) 
        case:
	    fmt.assertf (false, "fatal internal error in Win_Choice")
	}
    }
    
    name_with_id := std.gensym("Win_Choice")
    instp := new (Win_Instance_Data)
    return zd.make_leaf (name_with_id, owner, instp^, handle)
}

Die_Instance_Data :: struct {
    latchmap : Latched_Messages
}

Die_Choice :: proc (name: string, owner : ^zd.Eh) -> ^zd.Eh {
    handle :: proc (eh: ^zd.Eh, msg: ^zd.Message) {
	inst := &eh.instance_data.(Die_Instance_Data)
	switch msg.port {
	case "buy?":
	    latch (&inst.latchmap, msg)
	case "ask":
	    send_choice (eh, &inst.latchmap, die_menu, msg) 
        case:
	    fmt.assertf (false, "fatal internal error in Die_Choice")
	}
    }
    
    name_with_id := std.gensym("Die_Choice")
    instp := new (Die_Instance_Data)
    return zd.make_leaf (name_with_id, owner, instp^, handle)
}

