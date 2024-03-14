LIBSRC=../0D/odin/std
ODIN_FLAGS ?= -debug -o:none
D2J=../0d/das2json/das2json

dev: clean run-test-2

run : run-test-1 run-test-2

run-test-1: test transpile.drawio.json
	./test 1 main test.drawio $(LIBSRC)/transpile.drawio

run-test-2: test transpile.drawio.json
	./test 2 main test.drawio $(LIBSRC)/transpile.drawio

test: test.drawio.json
	odin build . $(ODIN_FLAGS)

test.drawio.json: test.drawio transpile.drawio.json
	$(D2J) test.drawio

transpile.drawio.json: $(LIBSRC)/transpile.drawio
	$(D2J) $(LIBSRC)/transpile.drawio

clean:
	rm -rf test test.dSYM *~ *.json
