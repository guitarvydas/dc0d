package repl

import zd "0d/odin"
import "0d/odin/std"

Tracing_Level : enum {none, minimum, medium, all}

Registers :: struct {
    inst : ^zd.Eh,
    trace : Tracing_Level,
    palette : zd.Component_Registry
}

repl :: proc () {
    reg := new (Registers)
    reset_repl (&reg)
    for true {
	line := get_line_from_terminal ("> ")
	command, arg := parse_command (line)
	switch command {
	case "j":
	case "l":
	case "f"
	case "b":
	case "i":
	case "d":
	case "o":
	case "z":
	case "p":
	case :
	}
    }
}

set_trace_none :: proc (r : ^Registers) {
    r.trace = .none
}

set_trace_minimum :: proc (r : ^Registers) {
    r.trace = .minimum
}

set_trace_medium :: proc (r : ^Registers) {
    r.trace = .medium
}

set_trace_all :: proc (r : ^Registers) {
    r.trace = .all
}

reset_repl :: proc (r : ^Registers) {
    reg.trace = .none
    if reg.palette != nil {
	zd.reclaim_registry_memory (reg.palette)
	reg.palette = nil
    }
}

das2json :: proc (r : ^Registers, filename : string) {
}

load :: proc (r : ^Registers, filename : string) {
    descriptor_array := json2internal (filename : string)
    for d in descriptor_array {
	zd.superceding_install_component_template (r.palette, d)
    }
}

set_inst :: proc (r : ^Registers, component : ^Eh) {
    deep_free_inst_component (r)
    r.inst = component
}

build :: proc (r : ^Registers, component_name : string) {
    deep_free_inst_component (r)
    ok : bool
    r.inst, ok = get_component_instance (r, component_name, owner=nil) -> (instance: ^Eh, ok: bool) 
    if !ok {
	fmt.printf ("can't find component %v\n", component_name)
	r.inst = nil
    }
}

prompt_for_value :: proc (r : ^Registers, port_name : string) -> string {
    line := get_line_from_terminal (fmt.aprintf ("%v?> ", port_name))
    return line
}

inject :: proc (r : ^Registers, port_name : string, value : string) {
    d := zd.new_datum_string (arg)
    msg := zd.make_message(port_name, d, zd.make_cause (r.inst, nil) )
    r.inst.handler(r.inst, msg)
}

display_palette :: proc (r : ^Registers) {
    zd.dump_registry (r.palette)
}


print_specific_output :: proc (r : ^Registers, port_name : string) {
    zd.print_specific_output (eh=r.inst, port=port_name, stderr=false) {
}

print_all_outputs :: proc (r : ^Registers) {
    print_output_list proc(eh=r.inst) {
}


///////////

deep_free_inst_component_instance :: proc (r : ^Registers) {
    if r.inst != nil {
	zd.reclaim_Eh_memory (r.inst)
    }
}
