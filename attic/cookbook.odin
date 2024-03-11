//

Shell_buffer :: struct {
    buffer : string
}

shell_out :: proc (name : string, owner : ^zd.Eh) -> ^zd.Eh {
    handle :: proc (eh: ^zd.Eh, msg: ^zd.Message) {
        fmt.println (msg)
        inst := &eh.instance_data.(Shell_buffer)
        switch msg.port {
        case "arg":
            inst.buffer = fmt.aprintf ("%v%v", inst.buffer, msg.datum.repr (msg.datum))
        case "run":
            fmt.println ("run", inst.buffer)
            stdout, stderr := zd.run_command (inst.buffer, "")
            fmt.println ("EXIT run")
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

