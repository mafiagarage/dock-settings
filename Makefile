# Basic Makefile

UUID = dash-to-dock@micxgx.gmail.com
BASE_MODULES = extension.js stylesheet.css metadata.json COPYING README.md
EXTRA_MODULES = convenience.js dash.js docking.js appIcons.js windowPreview.js intellihide.js prefs.js theming.js utils.js Settings.ui
EXTRA_MEDIA = logo.svg
TOLOCALIZE =  prefs.js appIcons.js
MSGSRC = $(wildcard po/*.po)
ifeq ($(strip $(DESTDIR)),)
	INSTALLTYPE = local
	INSTALLBASE = $(HOME)/.local/share/gnome-shell/extensions
else
	INSTALLTYPE = system
	SHARE_PREFIX = $(DESTDIR)/usr/share
	INSTALLBASE = $(SHARE_PREFIX)/gnome-shell/extensions
endif
INSTALLNAME = dash-to-dock@micxgx.gmail.com

all:

install: install-local

install-local: _build
	rm -rf $(INSTALLBASE)/$(INSTALLNAME)
	mkdir -p $(INSTALLBASE)/$(INSTALLNAME)
	cp -r ./_build/* $(INSTALLBASE)/$(INSTALLNAME)/
ifeq ($(INSTALLTYPE),system)
	# system-wide settings and locale files
	rm -r $(INSTALLBASE)/$(INSTALLNAME)/schemas $(INSTALLBASE)/$(INSTALLNAME)/locale
	mkdir -p $(SHARE_PREFIX)/glib-2.0/schemas $(SHARE_PREFIX)/locale
	cp -r ./schemas/*gschema.* $(SHARE_PREFIX)/glib-2.0/schemas
	cp -r ./_build/locale/* $(SHARE_PREFIX)/locale
endif
	-rm -fR _build
	echo done

zip-file: _build
	cd _build ; \
	zip -qr "$(UUID)$(VSTRING).zip" .
	mv _build/$(UUID)$(VSTRING).zip ./
	-rm -fR _build

_build: all
	-rm -fR ./_build
	mkdir -p _build
	cp $(BASE_MODULES) _build
