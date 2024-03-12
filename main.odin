package dc0d

import "core:fmt"
import "core:math/rand"

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
    zd.append_leaf (leaves, zd.Leaf_Template { name = "Demux 4", instantiate = demux4 })
    zd.append_leaf (leaves, zd.Leaf_Template { name = "Random", instantiate = random0d })
    zd.append_leaf (leaves, std.string_constant ("'adventure;shop;rest;quit'"))
    zd.append_leaf (leaves, std.string_constant ("'fight;flee'"))
    zd.append_leaf (leaves, std.string_constant ("'go home;continue'"))
    zd.append_leaf (leaves, std.string_constant ("'quit;restart'"))
    zd.append_leaf (leaves, std.string_constant ("'buy;leave'"))
    zd.append_leaf (leaves, std.string_constant ("'leave'"))
    zd.append_leaf (leaves, zd.Leaf_Template { name = "š", instantiate = shell_out })
    zd.append_leaf (leaves, std.string_constant ("node dialog.js "))
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
    
    name_with_id := std.gensym("demux4")
    return zd.make_leaf (name_with_id, owner, nil, handle)
}

//
random0d :: proc (name : string, owner : ^zd.Eh) -> ^zd.Eh {
    handle :: proc (eh: ^zd.Eh, msg: ^zd.Message) {
        // incoming datum is a string, containing a digit 1-4, pulse the corresponding output
        pulse := zd.new_datum_bang ()
        data: [2]int = { 1, 2 }
        switch rand.choice (data[:]) {
        case 1:
            zd.send (eh, "1", pulse, msg)
        case 2:
            zd.send (eh, "2", pulse, msg)
        case:
            fmt.assertf (false, "fatal internal error in random")
        }
    }
    
    name_with_id := std.gensym("Random")
    return zd.make_leaf (name_with_id, owner, nil, handle)
}

///


Shell_buffer :: struct {
    buffer : string
}

shell_out :: proc (name : string, owner : ^zd.Eh) -> ^zd.Eh {
    handle :: proc (eh: ^zd.Eh, msg: ^zd.Message) {
        inst := &eh.instance_data.(Shell_buffer)
        switch msg.port {
        case "arg":
            inst.buffer = fmt.aprintf ("%v%v", inst.buffer, msg.datum.repr (msg.datum))
        case "run":
            stdout, stderr := zd.run_command (inst.buffer, "")
            inst.buffer = ""
            if len (stderr) > 0 {
                zd.send_string (eh, "✗", stderr, msg)
            } else {
                zd.send_string (eh, "", stdout, msg)
            }
        case:
            fmt.assertf (false, "FATAL internal error in shell_out %v", msg)
        }
    }
    name_with_id := std.gensym("shell_out")
    instp := new (Shell_buffer)
    instp.buffer = ""
    return zd.make_leaf (name_with_id, owner, instp^, handle)
}

^^^^ need to replace shell_out with a native menu component, because shell-out grabs the console and we don't want that to happen
