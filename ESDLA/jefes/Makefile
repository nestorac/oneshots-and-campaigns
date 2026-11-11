# Primero incluye el Makefile común original
include ../../tools/Makefile.common

GRITH_MD   := grith.md
GRITH_CSS  := grith.css
GRITH_HTML := $(OUT_DIR)/grith.html
GRITH_PDF  := $(OUT_DIR)/grith.pdf

# Objetivo por defecto: grith con WeasyPrint
.DEFAULT_GOAL := grith

.PHONY: grith clean all

all: grith

grith: $(GRITH_PDF)

$(GRITH_HTML): $(GRITH_MD) $(GRITH_CSS) | $(OUT_DIR)
	pandoc "$(GRITH_MD)" -o "$(GRITH_HTML)" \
	  --from=markdown+smart \
	  --standalone \
	  --css=$(GRITH_CSS) \
	  --resource-path=.:img/

$(GRITH_PDF): $(GRITH_HTML)
	weasyprint "$(GRITH_HTML)" "$(GRITH_PDF)"

clean:
	rm -f "$(GRITH_PDF)" "$(GRITH_HTML)"
