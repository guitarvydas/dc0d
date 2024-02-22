package dc0d
import "core:fmt"
import zd "0D/odin"

init :: proc (name: string, owner : ^zd.Eh) -> ^zd.Eh {
    handler :: proc (eh: ^zd.Eh, msg: ^zd.Message) {
	p.ok = max_recharge
	p.wallet = 0
	p.pwr = 4
	ndays = 0
	zd.send (eh=eh, port="", datum=zd.new_datum_bang (), causingMessage=msg) 
    }
    return zd.make_leaf ("init", owner, nil, handler)
}
Rest :: proc (name: string, owner : ^zd.Eh) -> ^zd.Eh {
    handler :: proc (eh: ^zd.Eh, msg: ^zd.Message) {
	p.ok = max_recharge
	ndays += 1
	zd.send (eh=eh, port="", datum=zd.new_datum_string (fmt.aprintf ("p=%v m=%v ndays=%v\n", p, m, ndays)), causingMessage=msg)
	zd.send (eh=eh, port="", datum=zd.new_datum_bang (), causingMessage=msg) 
    }
    return zd.make_leaf ("Rest", owner, nil, handler)
}
updgrade :: proc (name: string, owner : ^zd.Eh) -> ^zd.Eh {
    handler :: proc (eh: ^zd.Eh, msg: ^zd.Message) {
	p.pwr += damage_sword
	p.wallet -= cost_sword
	zd.send (eh=eh, port="", datum=zd.new_datum_bang (), causingMessage=msg) 
    }
    return zd.make_leaf ("updgrade", owner, nil, handler)
}
pred_0 :: proc (name: string, owner : ^zd.Eh) -> ^zd.Eh {
    handler :: proc (eh: ^zd.Eh, msg: ^zd.Message) {
	if (p.wallet >= cost_sword) {
            zd.send (eh=eh, port="yes", datum=zd.new_datum_bang (), causingMessage=msg)
        } else {
            zd.send (eh=eh, port="no", datum=zd.new_datum_bang (), causingMessage=msg)
        }
    }
    return zd.make_leaf ("pred_0", owner, nil, handler)
}
Generate_Monster :: proc (name: string, owner : ^zd.Eh) -> ^zd.Eh {
    handler :: proc (eh: ^zd.Eh, msg: ^zd.Message) {
	m.wallet = cost_sword
	m.ok = max_recharge
	m.pwr = damage_sword
	zd.send (eh=eh, port="", datum=zd.new_datum_bang (), causingMessage=msg) 
    }
    return zd.make_leaf ("Generate Monster", owner, nil, handler)
}
adventure :: proc (name: string, owner : ^zd.Eh) -> ^zd.Eh {
    handler :: proc (eh: ^zd.Eh, msg: ^zd.Message) {
	spoils := 0
	zd.send (eh=eh, port="", datum=zd.new_datum_bang (), causingMessage=msg) 
    }
    return zd.make_leaf ("adventure", owner, nil, handler)
}
Damage_Player :: proc (name: string, owner : ^zd.Eh) -> ^zd.Eh {
    handler :: proc (eh: ^zd.Eh, msg: ^zd.Message) {
	p.ok -= msg.datum.data.(int)
	zd.send (eh=eh, port="", datum=zd.new_datum_bang (), causingMessage=msg) 
    }
    return zd.make_leaf ("Damage Player", owner, nil, handler)
}
Damage_Monster :: proc (name: string, owner : ^zd.Eh) -> ^zd.Eh {
    handler :: proc (eh: ^zd.Eh, msg: ^zd.Message) {
	m.ok -= msg.datum.data.(int)
	zd.send (eh=eh, port="", datum=zd.new_datum_bang (), causingMessage=msg) 
    }
    return zd.make_leaf ("Damage Monster", owner, nil, handler)
}
pred_1 :: proc (name: string, owner : ^zd.Eh) -> ^zd.Eh {
    handler :: proc (eh: ^zd.Eh, msg: ^zd.Message) {
	if (p.ok == 0) {
            zd.send (eh=eh, port="yes", datum=zd.new_datum_bang (), causingMessage=msg)
        } else {
            zd.send (eh=eh, port="no", datum=zd.new_datum_bang (), causingMessage=msg)
        }
    }
    return zd.make_leaf ("pred_1", owner, nil, handler)
}
pred_2 :: proc (name: string, owner : ^zd.Eh) -> ^zd.Eh {
    handler :: proc (eh: ^zd.Eh, msg: ^zd.Message) {
	if (m.ok == 0) {
            zd.send (eh=eh, port="yes", datum=zd.new_datum_bang (), causingMessage=msg)
        } else {
            zd.send (eh=eh, port="no", datum=zd.new_datum_bang (), causingMessage=msg)
        }
    }
    return zd.make_leaf ("pred_2", owner, nil, handler)
}
pred_3 :: proc (name: string, owner : ^zd.Eh) -> ^zd.Eh {
    handler :: proc (eh: ^zd.Eh, msg: ^zd.Message) {
	if (m.ok - p.pwr <= 0) {
            zd.send (eh=eh, port="yes", datum=zd.new_datum_bang (), causingMessage=msg)
        } else {
            zd.send (eh=eh, port="no", datum=zd.new_datum_bang (), causingMessage=msg)
        }
    }
    return zd.make_leaf ("pred_3", owner, nil, handler)
}
hitmonster :: proc (name: string, owner : ^zd.Eh) -> ^zd.Eh {
    handler :: proc (eh: ^zd.Eh, msg: ^zd.Message) {
	zd.send (eh, "", zd.new_datum_string (int2string (p.pwr)), msg)
    }
    return zd.make_leaf ("hitmonster", owner, nil, handler)
}
hitplayer :: proc (name: string, owner : ^zd.Eh) -> ^zd.Eh {
    handler :: proc (eh: ^zd.Eh, msg: ^zd.Message) {
	zd.send (eh, "", zd.new_datum_string (int2string (m.pwr)), msg)
    }
    return zd.make_leaf ("hitplayer", owner, nil, handler)
}
pred_4 :: proc (name: string, owner : ^zd.Eh) -> ^zd.Eh {
    handler :: proc (eh: ^zd.Eh, msg: ^zd.Message) {
	if (p.ok - m.pwr <= 0) {
            zd.send (eh=eh, port="yes", datum=zd.new_datum_bang (), causingMessage=msg)
        } else {
            zd.send (eh=eh, port="no", datum=zd.new_datum_bang (), causingMessage=msg)
        }
    }
    return zd.make_leaf ("pred_4", owner, nil, handler)
}
Collect :: proc (name: string, owner : ^zd.Eh) -> ^zd.Eh {
    handler :: proc (eh: ^zd.Eh, msg: ^zd.Message) {
	p.wallet += m.wallet
	m.wallet = 0
	zd.send (eh=eh, port="", datum=zd.new_datum_bang (), causingMessage=msg) 
    }
    return zd.make_leaf ("Collect", owner, nil, handler)
}
generated_components_to_include_in_project :: proc (leaves: ^[dynamic]zd.Leaf_Template) {
    zd.append_leaf (leaves, zd.Leaf_Template { name = "init", instantiate = init })
    zd.append_leaf (leaves, zd.Leaf_Template { name = "Do Rest", instantiate = Rest })
    zd.append_leaf (leaves, zd.Leaf_Template { name = "updgrade", instantiate = updgrade })
    zd.append_leaf (leaves, zd.Leaf_Template { name = "pred_0", instantiate = pred_0 })
    zd.append_leaf (leaves, zd.Leaf_Template { name = "Generate Monster", instantiate = Generate_Monster })
    zd.append_leaf (leaves, zd.Leaf_Template { name = "adventure", instantiate = adventure })
    zd.append_leaf (leaves, zd.Leaf_Template { name = "Damage Player", instantiate = Damage_Player })
    zd.append_leaf (leaves, zd.Leaf_Template { name = "Damage Monster", instantiate = Damage_Monster })
    zd.append_leaf (leaves, zd.Leaf_Template { name = "pred_1", instantiate = pred_1 })
    zd.append_leaf (leaves, zd.Leaf_Template { name = "pred_2", instantiate = pred_2 })
    zd.append_leaf (leaves, zd.Leaf_Template { name = "pred_3", instantiate = pred_3 })
    zd.append_leaf (leaves, zd.Leaf_Template { name = "hitmonster", instantiate = hitmonster })
    zd.append_leaf (leaves, zd.Leaf_Template { name = "hitplayer", instantiate = hitplayer })
    zd.append_leaf (leaves, zd.Leaf_Template { name = "pred_4", instantiate = pred_4 })
    zd.append_leaf (leaves, zd.Leaf_Template { name = "Collect", instantiate = Collect })
}
