LIBSRC=0D/odin/std
ODIN_FLAGS ?= -debug -o:none
D2J=0d/das2json/das2json
GEN0DDIR=./gen0D
GEN0D=${GEN0DDIR}/gen0d



dev: clean generated.odin run

run: dc0d transpile.drawio.json generated.odin
	./dc0d ! main dc0d.drawio $(LIBSRC)/transpile.drawio

dc0d: dc0d.drawio.json
	odin build . $(ODIN_FLAGS)

dc0d.drawio.json: dc0d.drawio transpile.drawio.json
	$(D2J) dc0d.drawio
	rm -f /tmp/dc0d.drawio.json
	cp dc0d.drawio.json dc0d.drawio.1.json
	node 0D/util/rmhtml.js dc0d.drawio.json >/tmp/dc0d.drawio.json
	cp /tmp/dc0d.drawio.json ./dc0d.drawio.json

transpile.drawio.json: $(LIBSRC)/transpile.drawio
	$(D2J) $(LIBSRC)/transpile.drawio


clean:
	rm -rf dc0d dc0d.dSYM
	rm -rf *.json


