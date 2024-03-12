package play
import "core:fmt"
import "core:os"
import zd "../0d/odin"
import "../0d/odin/std"

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


main :: proc () {
    leaf_under_test := prompt ("test prompt", nil)
    menu_datum := zd.new_datum_string ("1=adventure 2=shop 3=rest 4=quit")
    msg := zd.make_message("", menu_datum, zd.make_cause (leaf_under_test, nil) )
    leaf_under_test.handler(leaf_under_test, msg)
    std.dump_outputs (leaf_under_test)

}
