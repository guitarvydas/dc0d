package generated
import "core:fmt"

// macro ("⁇", "p.wallet >= weapon.cost")
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
/*
%macro ⁇ ($s) {
  $name = %gensym ("pred") {
    $name ::  proc (name: string, owner : ^zd.Eh) -> ^zd.Eh {
	handler :: proc (eh: ^zd.Eh, msg: ^zd.Message) {
	    if ($s) {
		send (eh, "", zd.new_datum_bool (true), msg)
	    } else {
		send (eh, "", zd.new_datum_bool (false), msg)
	    }
	}
	instance_name := zd.gensym ("$name")
	return zd.make_leaf (instance_name, owner, nil, handler)
    }
  }
}
*/

// macro ("⟪choice⟫","
// "buy?", "buy", 
// "", "leave"
// ")
choice01 :: proc (name: string, owner : ^zd.Eh) -> ^zd.Eh {
    handler :: proc (eh: ^zd.Eh, msg: ^zd.Message) {
	exec_choice (eh, msg, []string{
	    "buy?", "buy", 
	    "", "leave" })
    }
    instance_name := zd.gensym ("choice01")
    return zd.make_leaf (instance_name, owner, nil, handler)
}
/*
%defmacro ⟪choice⟫ ($s) {
  $name = %gensym ("choice") {
    $name :: proc (name: string, owner : ^zd.Eh) -> ^zd.Eh {
	handler :: proc (eh: ^zd.Eh, msg: ^zd.Message) {
	    exec_choice (eh, msg, []string{
		"buy?", "buy", 
		"", "leave" })
	}
	instance_name := zd.gensym ("$name")
	return zd.make_leaf (instance_name, owner, nil, handler)
    }
  }
}
*/

// macro ("∷", "
// p.pwr += weapon.pwr
// p.wallet -= weapon.cost
// ")

subr01 :: proc (name: string, owner : ^zd.Eh) -> ^zd.Eh {
    handler :: proc (eh: ^zd.Eh, msg: ^zd.Message) {
	p.pwr += weapon.pwr
	p.wallet += weapon.cost
	send ("", bang)
    }
    instance_name := zd.gensym ("subr01")
    return zd.make_leaf (instance_name, owner, nil, handler)
}
    
/*
%macro ⟪choice⟫ ($s) {
  $name = %gensym ("subr") {
    $name :: proc (name: string, owner : ^zd.Eh) -> ^zd.Eh {
	handler :: proc (eh: ^zd.Eh, msg: ^zd.Message) {
	    p.pwr += weapon.pwr
	    p.wallet += weapon.cost
	    send ("", bang)
	}
	instance_name := zd.gensym ("$name")
	return zd.make_leaf (instance_name, owner, nil, handler)
    }
  }
}
*/
