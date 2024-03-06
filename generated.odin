
package dc0d
import "core:fmt"
import zd "0d/odin"

init :: proc (name: string, owner : ^zd.Eh) -> ^zd.Eh {
	handler :: proc (eh: ^zd.Eh, msg: ^zd.Message) {
	fmt.println ("*** init ***")
p.ok = max_recharge
p.wallet = 0
p.pwr = 4
ndays = 0
fmt.println ("*** init EXIT ***")
	zd.send (eh=eh, port="", datum=zd.new_datum_bang (), causingMessage=msg)
	}
	return zd.make_leaf ("\u0117init&#xa;fmt.println (\"*** init ***\")&#xa;p.ok = max_recharge&#xa;p.wallet = 0&#xa;p.pwr = 4&#xa;ndays = 0&#xa;fmt.println (\"*** init EXIT ***\")", owner, nil, handler)
    }
Rest1 :: proc (name: string, owner : ^zd.Eh) -> ^zd.Eh {
	handler :: proc (eh: ^zd.Eh, msg: ^zd.Message) {
	p.ok = max_recharge
ndays += 1
	zd.send (eh=eh, port="", datum=zd.new_datum_bang (), causingMessage=msg)
	}
	return zd.make_leaf ("\u0117Rest1&#xa;p.ok = max_recharge&#xa;ndays += 1", owner, nil, handler)
    }
Generate_Monster :: proc (name: string, owner : ^zd.Eh) -> ^zd.Eh {
	handler :: proc (eh: ^zd.Eh, msg: ^zd.Message) {
	m.wallet = cost_sword
m.ok = max_recharge
m.pwr = damage_sword
	zd.send (eh=eh, port="", datum=zd.new_datum_bang (), causingMessage=msg)
	}
	return zd.make_leaf ("\u0117Generate_Monster&#xa;m.wallet = cost_sword&#xa;m.ok = max_recharge&#xa;m.pwr = damage_sword", owner, nil, handler)
    }
adventure :: proc (name: string, owner : ^zd.Eh) -> ^zd.Eh {
	handler :: proc (eh: ^zd.Eh, msg: ^zd.Message) {
	spoils := 0
	zd.send (eh=eh, port="", datum=zd.new_datum_bang (), causingMessage=msg)
	}
	return zd.make_leaf ("\u0117adventure&#xa;spoils := 0", owner, nil, handler)
    }
damage_player :: proc (name: string, owner : ^zd.Eh) -> ^zd.Eh {
	handler :: proc (eh: ^zd.Eh, msg: ^zd.Message) {
	p.ok -= msg.datum.data.(int)
	zd.send (eh=eh, port="", datum=zd.new_datum_bang (), causingMessage=msg)
	}
	return zd.make_leaf ("\u0117damage_player&#xa;p.ok -= msg.datum.data.(int)", owner, nil, handler)
    }
damage_monster :: proc (name: string, owner : ^zd.Eh) -> ^zd.Eh {
	handler :: proc (eh: ^zd.Eh, msg: ^zd.Message) {
	m.ok -= msg.datum.data.(int)
	zd.send (eh=eh, port="", datum=zd.new_datum_bang (), causingMessage=msg)
	}
	return zd.make_leaf ("\u0117damage_monster&#xa;m.ok -= msg.datum.data.(int)", owner, nil, handler)
    }
f1 :: proc (name: string, owner : ^zd.Eh) -> ^zd.Eh {
	handler :: proc (eh: ^zd.Eh, msg: ^zd.Message) {
	  if (p.ok == 0) {
            zd.send (eh=eh, port="yes", datum=zd.new_datum_bang (), causingMessage=msg)
          } else {
            zd.send (eh=eh, port="no", datum=zd.new_datum_bang (), causingMessage=msg)
          }
	}
	return zd.make_leaf ("\u03bbf1 p.ok == 0", owner, nil, handler)
    }
f2 :: proc (name: string, owner : ^zd.Eh) -> ^zd.Eh {
	handler :: proc (eh: ^zd.Eh, msg: ^zd.Message) {
	  if (m.ok == 0) {
            zd.send (eh=eh, port="yes", datum=zd.new_datum_bang (), causingMessage=msg)
          } else {
            zd.send (eh=eh, port="no", datum=zd.new_datum_bang (), causingMessage=msg)
          }
	}
	return zd.make_leaf ("\u03bbf2 m.ok == 0", owner, nil, handler)
    }
f3 :: proc (name: string, owner : ^zd.Eh) -> ^zd.Eh {
	handler :: proc (eh: ^zd.Eh, msg: ^zd.Message) {
	  if (m.ok - p.pwr <= 0) {
            zd.send (eh=eh, port="yes", datum=zd.new_datum_bang (), causingMessage=msg)
          } else {
            zd.send (eh=eh, port="no", datum=zd.new_datum_bang (), causingMessage=msg)
          }
	}
	return zd.make_leaf ("\u03bbf3 m.ok - p.pwr <= 0", owner, nil, handler)
    }
hitmonster :: proc (name: string, owner : ^zd.Eh) -> ^zd.Eh {
	handler :: proc (eh: ^zd.Eh, msg: ^zd.Message) {
	zd.send (eh, "", zd.new_datum_int (p.pwr), msg)
	zd.send (eh=eh, port="", datum=zd.new_datum_bang (), causingMessage=msg)
	}
	return zd.make_leaf ("\u0117hitmonster&#xa;zd.send (eh, \"\", zd.new_datum_int (p.pwr), msg)", owner, nil, handler)
    }
hitplayer :: proc (name: string, owner : ^zd.Eh) -> ^zd.Eh {
	handler :: proc (eh: ^zd.Eh, msg: ^zd.Message) {
	zd.send (eh, "", zd.new_datum_int (m.pwr), msg)
	zd.send (eh=eh, port="", datum=zd.new_datum_bang (), causingMessage=msg)
	}
	return zd.make_leaf ("\u0117hitplayer&#xa;zd.send (eh, \"\", zd.new_datum_int (m.pwr), msg)", owner, nil, handler)
    }
f4 :: proc (name: string, owner : ^zd.Eh) -> ^zd.Eh {
	handler :: proc (eh: ^zd.Eh, msg: ^zd.Message) {
	  if (p.ok - m.pwr <= 0) {
            zd.send (eh=eh, port="yes", datum=zd.new_datum_bang (), causingMessage=msg)
          } else {
            zd.send (eh=eh, port="no", datum=zd.new_datum_bang (), causingMessage=msg)
          }
	}
	return zd.make_leaf ("\u03bbf4 p.ok - m.pwr <= 0", owner, nil, handler)
    }
Collect :: proc (name: string, owner : ^zd.Eh) -> ^zd.Eh {
	handler :: proc (eh: ^zd.Eh, msg: ^zd.Message) {
	p.wallet += m.wallet
m.wallet = 0
	zd.send (eh=eh, port="", datum=zd.new_datum_bang (), causingMessage=msg)
	}
	return zd.make_leaf ("\u0117Collect&#xa;p.wallet += m.wallet&#xa;m.wallet = 0", owner, nil, handler)
    }
upgrade :: proc (name: string, owner : ^zd.Eh) -> ^zd.Eh {
	handler :: proc (eh: ^zd.Eh, msg: ^zd.Message) {
	p.pwr += damage_sword
p.wallet -= cost_sword
	zd.send (eh=eh, port="", datum=zd.new_datum_bang (), causingMessage=msg)
	}
	return zd.make_leaf ("\u0117upgrade&#xa;p.pwr += damage_sword&#xa;p.wallet -= cost_sword", owner, nil, handler)
    }
f0 :: proc (name: string, owner : ^zd.Eh) -> ^zd.Eh {
	handler :: proc (eh: ^zd.Eh, msg: ^zd.Message) {
	  if (p.wallet >= cost_sword) {
            zd.send (eh=eh, port="yes", datum=zd.new_datum_bang (), causingMessage=msg)
          } else {
            zd.send (eh=eh, port="no", datum=zd.new_datum_bang (), causingMessage=msg)
          }
	}
	return zd.make_leaf ("\u03bbf0 p.wallet >= cost_sword", owner, nil, handler)
    }
generated_components_to_include_in_project :: proc (leaves: ^[dynamic]zd.Leaf_Template) {
zd.append_leaf (leaves, zd.Leaf_Template { name = "\u0117init&#xa;fmt.println (\"*** init ***\")&#xa;p.ok = max_recharge&#xa;p.wallet = 0&#xa;p.pwr = 4&#xa;ndays = 0&#xa;fmt.println (\"*** init EXIT ***\")", instantiate = init })
zd.append_leaf (leaves, zd.Leaf_Template { name = "\u0117Rest1&#xa;p.ok = max_recharge&#xa;ndays += 1", instantiate = Rest1 })
zd.append_leaf (leaves, zd.Leaf_Template { name = "\u0117Generate_Monster&#xa;m.wallet = cost_sword&#xa;m.ok = max_recharge&#xa;m.pwr = damage_sword", instantiate = Generate_Monster })
zd.append_leaf (leaves, zd.Leaf_Template { name = "\u0117adventure&#xa;spoils := 0", instantiate = adventure })
zd.append_leaf (leaves, zd.Leaf_Template { name = "\u0117damage_player&#xa;p.ok -= msg.datum.data.(int)", instantiate = damage_player })
zd.append_leaf (leaves, zd.Leaf_Template { name = "\u0117damage_monster&#xa;m.ok -= msg.datum.data.(int)", instantiate = damage_monster })
zd.append_leaf (leaves, zd.Leaf_Template { name = "\u03bbf1 p.ok == 0", instantiate = f1 })
zd.append_leaf (leaves, zd.Leaf_Template { name = "\u03bbf2 m.ok == 0", instantiate = f2 })
zd.append_leaf (leaves, zd.Leaf_Template { name = "\u03bbf3 m.ok - p.pwr <= 0", instantiate = f3 })
zd.append_leaf (leaves, zd.Leaf_Template { name = "\u0117hitmonster&#xa;zd.send (eh, \"\", zd.new_datum_int (p.pwr), msg)", instantiate = hitmonster })
zd.append_leaf (leaves, zd.Leaf_Template { name = "\u0117hitplayer&#xa;zd.send (eh, \"\", zd.new_datum_int (m.pwr), msg)", instantiate = hitplayer })
zd.append_leaf (leaves, zd.Leaf_Template { name = "\u03bbf4 p.ok - m.pwr <= 0", instantiate = f4 })
zd.append_leaf (leaves, zd.Leaf_Template { name = "\u0117Collect&#xa;p.wallet += m.wallet&#xa;m.wallet = 0", instantiate = Collect })
zd.append_leaf (leaves, zd.Leaf_Template { name = "\u0117upgrade&#xa;p.pwr += damage_sword&#xa;p.wallet -= cost_sword", instantiate = upgrade })
zd.append_leaf (leaves, zd.Leaf_Template { name = "\u03bbf0 p.wallet >= cost_sword", instantiate = f0 })
}

