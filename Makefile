LIBSRC=0D/odin/std
ODIN_FLAGS ?= -debug -o:none
D2J=0d/das2json/das2json

dev: clean run

run: dc0d transpile.drawio.json
	./dc0d main dc0d.drawio $(LIBSRC)/transpile.drawio

dc0d: dc0d.drawio.json
	odin build . $(ODIN_FLAGS)

dc0d.drawio.json: dc0d.drawio transpile.drawio.json
	$(D2J) dc0d.drawio
	python3 0D/util/rmformatting.py <dc0d.drawio.json >/tmp/dc0d.drawio.json
	cp /tmp/dc0d.drawio.json ./dc0d.drawio.json

transpile.drawio.json: $(LIBSRC)/transpile.drawio
	$(D2J) $(LIBSRC)/transpile.drawio

clean:
	rm -rf dc0d dc0d.dSYM
	rm -rf *.json

