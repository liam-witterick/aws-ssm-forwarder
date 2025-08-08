PREFIX ?= /usr/local
BINDIR ?= $(PREFIX)/bin
BIN    ?= ssm-tunnel

install:
	@mkdir -p "$(BINDIR)"
	@chmod +x "bin/$(BIN)"
	@cp "bin/$(BIN)" "$(BINDIR)/$(BIN)"
	@echo "Installed $(BIN) to $(BINDIR)/$(BIN)"

uninstall:
	@rm -f "$(BINDIR)/$(BIN)"
	@echo "Removed $(BINDIR)/$(BIN)"

.PHONY: install uninstall
