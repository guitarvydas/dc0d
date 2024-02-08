# ultra simple - client sends JS that causes something to be displayed on the GUI, gathers response from user, prints response on stdout, then quits

# concrete example: client sends request to display a menu of 4 items, user choice is printed on stdout
$ gui-server start
$ gui-server command "js/html code that displays a menu of 4 items then prints which item was chosen"
3
$ gui-server stop


# in the worst case, we use all of CLOG+SBCL to display this simple menu:
$ clog-app "choice 1 ; choice 2 ; choice 3 ; choice 4"
3
$

# the strings for choices are generated on-the-fly and cannot be baked into the CLOG app

# future consideration
# my app, not written in CL, wants to display and interact with the GUI
# can it spin up a CLOG app and talk to it via a socket or some kind of IPC?

# in fact, can the CLOG app communciate with the gui-server app via a socket instead of CL code? I.E. send a string containing JS, get a string in response.
# I.E. $ my-app <=> CLOG <=> gui-server
#   or $ my-app <=> gui-server
#
#   or for those who are squemish about using sockets (like me)... 
#   or $ my-app >in.txt \
#      $ gui-server command <in.txt >out.txt


# most brain-dead version... (maybe you already have this?)

$ gui-server start
$ my-app >in.txt
$ gui-server exec <in.txt
3
$ gui-server stop

[ed. 'my-app' creates the JS code to to cause a simple menu consisting of 4 items to be displayed,
 when users selects 1 item from the menu, the item number is returned via websocket to gui-server
 gui-server then prints the item number on stdout, and dies.]

[N.B. in the above example, we imagine that the user selected item #3, which is then printed on stdout by gui-server]

[I.E. we use /bin/bash as a REPL for simple GUI-ing]

[N.B. the menu item strings are generated on-the-fly and should not be baked into the code for gui-server]

[Q: what code, exactly, should be in 'in.txt' to cause a simple menu consisting of 4 items to be displayed?]

[FUTURE, not now: gui-server is a big CLOG app that stays alive and communicates with my-app via a socket or IPC-thingie].

---

re-reading this, I see an even simpler and dumber version:

$ my-app >in.txt
$ gui-server run <in.txt
3

---

I continue playing with CLOG as a possibility for doing menus in Ceptre...

I think that I need this:

$ gui-server start
$ my-app >in.txt
$ gui-server exec <in.txt
3
$ gui-server stop

(or less, since start and stop can be subsumed into gui-server).

CLOG opens a browser and a websocket for a live connection to/from the GUI.

I sent this to Botton, and his response, paraphrased, is 'this is just a CGI application ... CLOG uses a websocket'.

I'm ignorant of CGI apps.  Can a CGI open a browser and build an HTMLscreen ("menu") on demand?

Orthogonal thread: it appears to me that the thing called 'gui-server' can be written to use a websocket, in any language and doesn't need all of CLOG+SBCL. If this thought isn't insane, then, exactly what JS (+HTML?) would be poured down the websocket (ie. input to 'gui-server' which simply echoes the input into the websocket and echoes the response from the GUI on stdout). Currently, CLOG does all of that and more, using CL. Surely you don't need CL to do that, but, maybe it is so ugly that you'd want to use CL???

 
