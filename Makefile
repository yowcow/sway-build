SWAY_VER := 1.6.1
SWAY_TAR := sway-$(SWAY_VER).tar.gz
SWAY_URL := https://github.com/swaywm/sway/releases/download/$(SWAY_VER)/$(SWAY_TAR)
SWAY_SRC := src/sway-$(SWAY_VER)

WLROOTS_VER := 0.14.1
WLROOTS_TAR := wlroots-$(WLROOTS_VER).tar.gz
WLROOTS_URL := https://github.com/swaywm/wlroots/releases/download/$(WLROOTS_VER)/$(WLROOTS_TAR)
WLROOTS_SRC := src/wlroots-$(WLROOTS_VER)

# https://github.com/swaywm/wlroots/issues/2888
SEATD_SRC := $(WLROOTS_SRC)/subprojects/seatd

all: $(SWAY_SRC) $(WLROOTS_SRC) $(SEATD_SRC)
	cd $(SEATD_SRC) && git pull

src/%: %.tar.gz
	mkdir -p $@
	tar xzf $< -C $@ --strip-components 1

$(SWAY_TAR):
	curl -L $(SWAY_URL) -o $@

$(WLROOTS_TAR):
	curl -L $(WLROOTS_URL) -o $@

$(SEATD_SRC): $(WLROOTS_SRC)
	mkdir -p $(dir $@)
	# pull whenever necessary
	git clone https://git.sr.ht/~kennylevinsen/seatd $@

clean:

realclean: clean
	rm -rf src

install: install/wlroots install/sway
	sudo ldconfig

install/wlroots:
	cd $(WLROOTS_SRC) && \
		meson build && \
		ninja -C build && \
		sudo ninja -C build install

install/sway:
	cd $(SWAY_SRC) && \
		meson build && \
		ninja -C build && \
		sudo ninja -C build install

.PHONY: all clean realclean install install/%
