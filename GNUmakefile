# articlelink            -*- makefile-gmake -*-
# GNUmakefile

PNAME = articlelink
DISPLAY = short
DLDCREPO = /data/web/dldc/opam
DUNE = opam exec -- dune $1 --display $(DISPLAY)
CGI_BIN = /data/local/apache/cgi-bin
RESTFUL_TEST_HOST = restful02.lib.uchicago.edu
RESTFUL_HOST = restful.lib.uchicago.edu
BSD_BUILD_HOST = ocaml.lib.uchicago.edu
BSD_BUILD_PATH = /usr/app/lib/opam-matt/git-projects

build all:
	$(call DUNE, build @@default)
.PHONY: build all

doc:
	$(call DUNE, build @doc)
.PHONY: doc

clean:
	$(call DUNE, clean)
.PHONY: clean

sandbox:
	opam switch remove $(PWD) --yes
	opam switch create . --deps-only --repos dldc=https://dldc.lib.uchicago.edu/opam,default --yes
PHONY: sandbox

deps:
	opam repository add dldc https://dldc.lib.uchicago.edu/opam
	opam install . --deps-only --yes
.PHONY: deps

dune-install: build
	opam exec -- $(call DUNE, install)
.PHONY: install

dev-install: dune-install
	install -m 555 $(OPAM_SWITCH_PREFIX)/bin/$(PNAME) ~/bin
.PHONY: home-install

dev-uninstall: 
	$(RM) ~/bin/$(PNAME)
.PHONY: home-install

mounts:
	if mountpoint /data/web 2> /dev/null; then : ; else sudo mkdir -p /data/web && sudo mount voldemort:/export/www-legacy /data/web ; fi
.PHONY: mounts

publish: TEMP_FILE := $(shell mktemp)
publish: build mounts
	cat $(PNAME).opam | grep dev-repo | awk '{ print $$2 }' > $(TEMP_FILE)
	echo 'url { src:' `cat $(TEMP_FILE)` '}' >> $(PNAME).opam
	make -C $(DLDCREPO) add NAME=$(PNAME) OPAM=$$PWD/$(PNAME).opam
.PHONY: publish

cgi:
	$(call DUNE, build)
	install -m 555 $(PWD)/_build/default/app/$(PNAME).exe $(PWD)/cgi-bin/$(PNAME)
.PHONY: cgi

bsd-restful02-deploy:
	git pull origin master
	opam exec -- dune build
	rsync -aizvP _build/default/app/$(PNAME).exe $(RESTFUL_TEST_HOST):$(CGI_BIN)/$(PNAME)
.PHONY: bsd-restful02-deploy

bsd-restful02-rebuild: sandbox bsd-restful02-deploy
.PHONY: bsd-restful02-rebuild

restful02-deploy:
	ssh $(BSD_BUILD_HOST) "make -C $(BSD_BUILD_PATH)/$(PNAME) bsd-restful02-deploy"
.PHONY: restful02-deploy

restful02-rebuild:
	ssh $(BSD_BUILD_HOST) "make -C $(BSD_BUILD_PATH)/$(PNAME) bsd-restful02-rebuild"
.PHONY: restful02-rebuild

restful02-remove:
	ssh $(RESTFUL_TEST_HOST) "rm $(CGI_BIN)/$(PNAME)"
.PHONY: restful02-remove

bsd-restful-deploy:
	git pull origin master
	opam exec -- dune build
	rsync -aizvP _build/default/app/$(PNAME).exe $(RESTFUL_HOST):$(CGI_BIN)/$(PNAME)
.PHONY: bsd-restful-deploy

bsd-restful-rebuild: sandbox bsd-restful-deploy
.PHONY: bsd-restful-rebuild

restful-deploy:
	ssh $(BSD_BUILD_HOST) "make -C $(BSD_BUILD_PATH)/$(PNAME) bsd-restful-deploy"
.PHONY: restful-deploy

restful-rebuild:
	ssh $(BSD_BUILD_HOST) "make -C $(BSD_BUILD_PATH)/$(PNAME) bsd-restful-rebuild"
.PHONY: restful-rebuild

restful-remove:
	ssh $(RESTFUL_HOST) "rm $(CGI_BIN)/$(PNAME)"
.PHONY: restful-remove

serve:
	althttpd -root $(PWD)/cgi-bin -port 3000
.PHONY: serve
