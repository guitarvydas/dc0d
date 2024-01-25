const fs = require ('fs');
const ohm = require ('ohm-js');

let argv;
let srcFileName;

let grammarSrc = fs.readFileSync ('generator0D.ohm', 'utf-8'); // read from file to maintain programmer's sanity
const grammar = ohm.grammar(grammarSrc);

const semantics = grammar.createSemantics();

// Register the semantic action
semantics.addOperation('gen', {
    chars : function (cs) { return cs.gen ().join (''); },

    char_esc : function (c) { return c.gen (); },
    char_macro : function (m) { return "\n" + "⟪" + m.gen () + "⟫"; },
    char_any : function (c) { return c.gen (); },

    innerchar_esc : function (c) { return c.gen (); },
    innerchar_macro : function (m) { return m.gen (); },
    innerchar_any : function (c) { return c.gen (); },

    anychar : function (c) { return this.sourceString; },
    
    escapedChar_dquote : function (_) { return '"'; },
    codeMacro: function (dq1, namecs, ws1, _defcode, ws2, cs, dq2) { return `${encodeURIComponent (cs.gen ().join (''))}`; },
    codechar_nested : function (dq1, cs, dq2) { return "\\\"" + cs.gen ().join ('') + "\\\""; },
    codechar_other : function (c) { return this.sourceString; },
    codeMark: function (x) { return "∷"; },
    _terminal: function () { return this.sourceString; },
    _iter: function (...children) { return children.map(c => c.gen ()); },
});

function main () {
    // top level command, prints on stdout and stderr (if error) then exits with 0 or 1 (OK, or not OK, resp.)
    try {
	argv = require('yargs/yargs')(process.argv.slice(2)).argv;
	srcFileName = argv._[0];
	let src = fs.readFileSync (srcFileName, 'utf-8');
	const match = grammar.match(src);
	if (match.succeeded()) {
	    const g = semantics(match).gen ();
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
