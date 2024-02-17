package make

Tracing :: enum {
    none,
    minimum,
    medium,
    maximum,
}

Registers :: struct {
    focus : string
    display: Tracing
    palette : Component_Registry
}

init_repl :: proc () {
    command := "0d/das2json/das2json 0D/odin/std/transpile.drawio")
    shell_out (command)
    load ("transpile.drawio.json")
}

das2json :: proc (filename : string ) {    
    command := fmt.aprintf ("0d/das2json/das2json %v", filename)
    shell_out (command)
}

load :: proc (filename : string) {
    std.load_components (filename)
