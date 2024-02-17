const fs = require ('fs');
const ohm = require ('ohm-js');

let argv;
let srcFileName;

let grammarSrc = fs.readFileSync ('encoder0D.ohm', 'utf-8'); // read from file to maintain programmer's sanity
const grammar = ohm.grammar(grammarSrc);

const semantics = grammar.createSemantics();

// Register the semantic action
semantics.addOperation('encmac', {
    chars : function (cs) { return cs.encmac ().join (''); },

    char_esc : function (c) { return c.encmac (); },
    char_macro : function (m) { return "\n" + m.encmac (); },
    char_any : function (c) { return c.encmac (); },

    innerchar_esc : function (c) { return c.encmac (); },
    innerchar_macro : function (m) { return m.encmac (); },
    innerchar_any : function (c) { return c.encmac (); },

    anychar : function (c) { return this.sourceString; },
    
    escapedChar_dquote : function (_) { return '"'; },
    codeMacro: function (dq1, namecs, _defcode, ws2, cs, dq2) { return `∷❨${encodeURIComponent (namecs.encmac ().join (''))}❩❨${encodeURIComponent (cs.encmac ().join (''))}❩`; },
    codechar_nested : function (dq1, cs, dq2) { return '"' + cs.encmac ().join ('') + '"'; },
    codechar_other : function (c) { return this.sourceString; },
    codechar_next: function (x) { return ' zd.send (eh=eh, port="", datum=zd.new_datum_bang (), causingMessage=msg) '; },

    codechar_dquote: function (c) { return '"';},
    codechar_backslash: function (c) { return '\\';},
    codechar_nl: function (c) { return '\n';},
    codechar_html: function (h) { return h; },
    
    namechar_html: function (c) {return c; },
    namechar_other: function (c) {return c; },

    codeMark: function (x) { return "∷"; },
    nextMark: function (x) { return "⇒"; },

    html: function (lb, cs, rb) { return "<" + cs.encmac ().join ('') + ">"; },

    _terminal: function () { return this.sourceString; },
    _iter: function (...children) { return children.map(c => c.encmac ()); },
});

function main () {
    // top level command, prints on stdout and stderr (if error) then exits with 0 or 1 (OK, or not OK, resp.)
    try {
	//argv = require('yargs/yargs')(process.argv.slice(2)).argv;
	//srcFileName = argv._[0];
	srcFileName = '/dev/fd/0';
	let src = fs.readFileSync (srcFileName, 'utf-8');
	const match = grammar.match(src);
	if (match.succeeded()) {
	    const g = semantics(match).encmac ();
	    console.log(g);
	} else {
	    throw 'Failed to match input string against the grammar';
	}
    } catch (e) {
	console.error (e.message.trim ());
	process.exit (1);
    }
}    

main ();
