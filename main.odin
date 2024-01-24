package project

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
    main_container_name, diagram_names := std.parse_command_line_args ()
    palette := std.initialize_component_palette (diagram_names, components_to_include_in_project)
    std.run_demo_debug (&palette, main_container_name, diagram_names, start_function)
}

start_function :: proc (main_container : ^zd.Eh) {
    x := zd.new_datum_bang ()
    msg := zd.make_message("", x, zd.make_cause (main_container, nil) )
    main_container.handler(main_container, msg)
}


components_to_include_in_project :: proc (leaves: ^[dynamic]zd.Leaf_Template) {
    //    zd.append_leaf (leaves, zd.Leaf_Template { name = "trash", instantiate = trash_instantiate })
    //    zd.append_leaf (leaves, std.string_constant ("rwr.ohm"))
    zd.append_leaf (leaves, zd.Leaf_Template { name = "= init p.ok = max_hp p.wallet = 0 p.pwr = 4 ndays = 0 zd.send(eh=eh, port=\"\", datum=zd.new_datum_bang (), causingMessage=nil)", instantiate = cold_start})
    zd.append_leaf (leaves, zd.Leaf_Template { name = "p.ok = max_recharge ndays += 1 fmt.println (p, ndays)", instantiate = rest})
}

cold_start :: proc (name: string, owner : ^zd.Eh) -> ^zd.Eh {
    handler :: proc (eh: ^zd.Eh, msg: ^zd.Message) {
	p.ok = max_recharge
	p.wallet = 0
	p.pwr = damage_sword
	ndays = 0
	zd.send(eh=eh, port="", datum=zd.new_datum_bang (), causingMessage=nil)
    }
    instance_name := zd.gensym ("cold_start")
    return zd.make_leaf (instance_name, owner, nil, handler)
}

rest ::  proc (name: string, owner : ^zd.Eh) -> ^zd.Eh {
    handler :: proc (eh: ^zd.Eh, msg: ^zd.Message) {
	p.ok = max_recharge
	ndays += 1
	fmt.println (p, ndays)	
    }
    instance_name := zd.gensym ("rest")
    return zd.make_leaf (instance_name, owner, nil, handler)
}

