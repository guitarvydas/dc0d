// npm install yargs
// npm install prompt-sync

const prompt = require("prompt-sync")({ sigint: true });

function pick (choices) {
    i = 1;
    for (let i = 0; i < choices.length; i++) {
	console.log (i+1, choices [i]);
    }
    let n = prompt ("pick one: ");
    n = n - 1;
    return n
}

function main () {
    argv = require('yargs/yargs')(process.argv.slice(2)).argv;
    console.error ();
    console.error ();
    console.error ("\033[101m>>> argv...", argv, "\033[0m");
    console.error ();
    choices = argv._[0].split (';');
    n = pick (choices);
    while (n < 0 || n >= choices.length) {
	n = console.log (`oops - choice out of range (1-${choices.length}) - pick again. `);
	n = pick (choices);
    }
    return n;
}

console.log (main ());

