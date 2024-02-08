package generated
import "core:fmt"

pred01 ::  proc (name: string, owner : ^zd.Eh) -> ^zd.Eh {
    handler :: proc (eh: ^zd.Eh, msg: ^zd.Message) {
	if (p.wallet >= weapon.cost) {
	    send (eh, "", zd.new_datum_bool (true), msg)
	} else {
	    send (eh, "", zd.new_datum_bool (false), msg)
	}
    }
    instance_name := zd.gensym ("pred01")
    return zd.make_leaf (instance_name, owner, nil, handler)
}
