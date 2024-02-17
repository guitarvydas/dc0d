package dc0d
import "core:fmt"
import "0d/odin/0d"

init :: proc (name: string, owner : ^zd.Eh) -> ^zd.Eh {
    handler :: proc (eh: ^zd.Eh, msg: ^zd.Message) {
	p.ok = max_recharge
	p.wallet = 0
	p.pwr = 4
	ndays = 0
	zd.send (eh=eh, port="", datum=zd.new_datum_bang (), causingMessage=msg) 
    }
    instance_name := zd.gensym ("init")
    return zd.make_leaf (instance_name, owner, nil, handler)
}
Rest :: proc (name: string, owner : ^zd.Eh) -> ^zd.Eh {
    handler :: proc (eh: ^zd.Eh, msg: ^zd.Message) {
	p.ok = max_recharge
	ndays += 1
	zd.send (eh=eh, port="", datum=zd.new_datum_string (fmt.aprintf ("p=%v m=%v ndays=%v\n", p, m, ndays)), causingMessage=msg)
	zd.send (eh=eh, port="", datum=zd.new_datum_bang (), causingMessage=msg) 
    }
    instance_name := zd.gensym ("Rest")
    return zd.make_leaf (instance_name, owner, nil, handler)
}
updgrade :: proc (name: string, owner : ^zd.Eh) -> ^zd.Eh {
    handler :: proc (eh: ^zd.Eh, msg: ^zd.Message) {
	p.pwr += damage_sword
	p.wallet -= cost_sword
	zd.send (eh=eh, port="", datum=zd.new_datum_bang (), causingMessage=msg) 
    }
    instance_name := zd.gensym ("updgrade")
    return zd.make_leaf (instance_name, owner, nil, handler)
}
pred_0 :: proc (name: string, owner : ^zd.Eh) -> ^zd.Eh {
    handler :: proc (eh: ^zd.Eh, msg: ^zd.Message) {
	if (p.wallet >= cost_sword) {
            zd.send (eh=eh, port="yes", datum=zd.new_datum_bang (), causingMessage=msg)
        } else {
            zd.send (eh=eh, port="no", datum=zd.new_datum_bang (), causingMessage=msg)
        }
    }
    instance_name := zd.gensym ("pred_0")
    return zd.make_leaf (instance_name, owner, nil, handler)
}
Generate_Monster :: proc (name: string, owner : ^zd.Eh) -> ^zd.Eh {
    handler :: proc (eh: ^zd.Eh, msg: ^zd.Message) {
	m.wallet = cost_sword
	m.ok = max_recharge
	m.pwr = damage_sword
	zd.send (eh=eh, port="", datum=zd.new_datum_bang (), causingMessage=msg) 
    }
    instance_name := zd.gensym ("Generate_Monster")
    return zd.make_leaf (instance_name, owner, nil, handler)
}
adventure :: proc (name: string, owner : ^zd.Eh) -> ^zd.Eh {
    handler :: proc (eh: ^zd.Eh, msg: ^zd.Message) {
	spoils := 0
	zd.send (eh=eh, port="", datum=zd.new_datum_bang (), causingMessage=msg) 
    }
    instance_name := zd.gensym ("adventure")
    return zd.make_leaf (instance_name, owner, nil, handler)
}
Damage_Player :: proc (name: string, owner : ^zd.Eh) -> ^zd.Eh {
    handler :: proc (eh: ^zd.Eh, msg: ^zd.Message) {
	p.ok -= N
	zd.send (eh=eh, port="", datum=zd.new_datum_bang (), causingMessage=msg) 
    }
    instance_name := zd.gensym ("Damage_Player")
    return zd.make_leaf (instance_name, owner, nil, handler)
}
Damage_Monster :: proc (name: string, owner : ^zd.Eh) -> ^zd.Eh {
    handler :: proc (eh: ^zd.Eh, msg: ^zd.Message) {
	m.ok -= N
	zd.send (eh=eh, port="", datum=zd.new_datum_bang (), causingMessage=msg) 
    }
    instance_name := zd.gensym ("Damage_Monster")
    return zd.make_leaf (instance_name, owner, nil, handler)
}
pred_5 :: proc (name: string, owner : ^zd.Eh) -> ^zd.Eh {
    handler :: proc (eh: ^zd.Eh, msg: ^zd.Message) {
	if (p.ok == 0) {
            zd.send (eh=eh, port="yes", datum=zd.new_datum_bang (), causingMessage=msg)
        } else {
            zd.send (eh=eh, port="no", datum=zd.new_datum_bang (), causingMessage=msg)
        }
    }
    instance_name := zd.gensym ("pred_5")
    return zd.make_leaf (instance_name, owner, nil, handler)
}
pred_6 :: proc (name: string, owner : ^zd.Eh) -> ^zd.Eh {
    handler :: proc (eh: ^zd.Eh, msg: ^zd.Message) {
	if (m.ok == 0) {
            zd.send (eh=eh, port="yes", datum=zd.new_datum_bang (), causingMessage=msg)
        } else {
            zd.send (eh=eh, port="no", datum=zd.new_datum_bang (), causingMessage=msg)
        }
    }
    instance_name := zd.gensym ("pred_6")
    return zd.make_leaf (instance_name, owner, nil, handler)
}
pred_13 :: proc (name: string, owner : ^zd.Eh) -> ^zd.Eh {
    handler :: proc (eh: ^zd.Eh, msg: ^zd.Message) {
	if (m.ok - p.pwr <= 0) {
            zd.send (eh=eh, port="yes", datum=zd.new_datum_bang (), causingMessage=msg)
        } else {
            zd.send (eh=eh, port="no", datum=zd.new_datum_bang (), causingMessage=msg)
        }
    }
    instance_name := zd.gensym ("pred_13")
    return zd.make_leaf (instance_name, owner, nil, handler)
}
hitmonster :: proc (name: string, owner : ^zd.Eh) -> ^zd.Eh {
    handler :: proc (eh: ^zd.Eh, msg: ^zd.Message) {
	zd.send (eh, "", zd.new_datum_int_as_string (p.pwr), msg)
    }
    instance_name := zd.gensym ("hitmonster")
    return zd.make_leaf (instance_name, owner, nil, handler)
}
hitplayer :: proc (name: string, owner : ^zd.Eh) -> ^zd.Eh {
    handler :: proc (eh: ^zd.Eh, msg: ^zd.Message) {
	zd.send (eh, "", zd.new_datum_int_as_string (m.pwr), msg)
    }
    instance_name := zd.gensym ("hitplayer")
    return zd.make_leaf (instance_name, owner, nil, handler)
}
pred_14 :: proc (name: string, owner : ^zd.Eh) -> ^zd.Eh {
    handler :: proc (eh: ^zd.Eh, msg: ^zd.Message) {
	if (p.ok - m.pwr <= 0) {
            zd.send (eh=eh, port="yes", datum=zd.new_datum_bang (), causingMessage=msg)
        } else {
            zd.send (eh=eh, port="no", datum=zd.new_datum_bang (), causingMessage=msg)
        }
    }
    instance_name := zd.gensym ("pred_14")
    return zd.make_leaf (instance_name, owner, nil, handler)
}
Collect :: proc (name: string, owner : ^zd.Eh) -> ^zd.Eh {
    handler :: proc (eh: ^zd.Eh, msg: ^zd.Message) {
	p.wallet += m.wallet
	m.wallet = 0
	zd.send (eh=eh, port="", datum=zd.new_datum_bang (), causingMessage=msg) 
    }
    instance_name := zd.gensym ("Collect")
    return zd.make_leaf (instance_name, owner, nil, handler)
}
generated_components_to_include_in_project :: proc (leaves: ^[dynamic]zd.Leaf_Template) {
    zd.append_leaf (leaves, zd.Leaf_Template { name = "init∷<br>p.ok = max_recharge<br>p.wallet = 0<br>p.pwr = 4<br>ndays = 0<br> zd.send (eh=eh, port=\"\", datum=zd.new_datum_bang (), causingMessage=msg) ", instantiate = init })
    zd.append_leaf (leaves, zd.Leaf_Template { name = "Rest∷<br>p.ok = max_recharge<br>ndays += 1<br>zd.send (eh=eh, port=\"\", datum=zd.new_datum_string (fmt.aprintf (\"p=%v m=%v ndays=%v\n\", p, m, ndays)), causingMessage=msg)<br> zd.send (eh=eh, port=\"\", datum=zd.new_datum_bang (), causingMessage=msg) ", instantiate = Rest })
    zd.append_leaf (leaves, zd.Leaf_Template { name = "updgrade∷<br>p.pwr += damage_sword<br>p.wallet -= cost_sword<br> zd.send (eh=eh, port=\"\", datum=zd.new_datum_bang (), causingMessage=msg) ", instantiate = updgrade })
    zd.append_leaf (leaves, zd.Leaf_Template { name = "pred_0∷p.wallet >= cost_sword", instantiate = pred_0 })
    zd.append_leaf (leaves, zd.Leaf_Template { name = "Generate_Monster∷<br>m.wallet = cost_sword<br>m.ok = max_recharge<br>m.pwr = damage_sword<br> zd.send (eh=eh, port=\"\", datum=zd.new_datum_bang (), causingMessage=msg) ", instantiate = Generate_Monster })
    zd.append_leaf (leaves, zd.Leaf_Template { name = "adventure∷<br>spoils := 0<br> zd.send (eh=eh, port=\"\", datum=zd.new_datum_bang (), causingMessage=msg) ", instantiate = adventure })
    zd.append_leaf (leaves, zd.Leaf_Template { name = "Damage_Player∷<br>p.ok -= N<br> zd.send (eh=eh, port=\"\", datum=zd.new_datum_bang (), causingMessage=msg) ", instantiate = Damage_Player })
    zd.append_leaf (leaves, zd.Leaf_Template { name = "Damage_Monster∷<br>m.ok -= N<br> zd.send (eh=eh, port=\"\", datum=zd.new_datum_bang (), causingMessage=msg) ", instantiate = Damage_Monster })
    zd.append_leaf (leaves, zd.Leaf_Template { name = "pred_5∷p.ok == 0", instantiate = pred_5 })
    zd.append_leaf (leaves, zd.Leaf_Template { name = "pred_6∷m.ok == 0", instantiate = pred_6 })
    zd.append_leaf (leaves, zd.Leaf_Template { name = "pred_13∷m.ok - p.pwr <= 0", instantiate = pred_13 })
    zd.append_leaf (leaves, zd.Leaf_Template { name = "hitmonster∷<br>zd.send (eh, \"\", zd.new_datum_int_as_string (p.pwr), msg)", instantiate = hitmonster })
    zd.append_leaf (leaves, zd.Leaf_Template { name = "hitplayer∷<br>zd.send (eh, \"\", zd.new_datum_int_as_string (m.pwr), msg)", instantiate = hitplayer })
    zd.append_leaf (leaves, zd.Leaf_Template { name = "pred_14∷p.ok - m.pwr <= 0", instantiate = pred_14 })
    zd.append_leaf (leaves, zd.Leaf_Template { name = "Collect∷<br>p.wallet += m.wallet<br>m.wallet = 0<br> zd.send (eh=eh, port=\"\", datum=zd.new_datum_bang (), causingMessage=msg) ", instantiate = Collect })}
