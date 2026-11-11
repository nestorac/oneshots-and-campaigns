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

$(OUT_DIR):
	mkdir -p $(OUT_DIR)

$(GRITH_HTML): $(GRITH_MD) $(GRITH_CSS) | $(OUT_DIR)
	cp "$(GRITH_CSS)" "$(OUT_DIR)/"
	# Copia o enlace de imágenes para que WeasyPrint las encuentre
	mkdir -p "$(OUT_DIR)/img"
	cp -a img/. "$(OUT_DIR)/img/" 2>/dev/null || true
	pandoc "$(GRITH_MD)" -o "$(GRITH_HTML)" \
	  --from=markdown+smart \
	  --standalone \
	  --css=grith.css \
	  --resource-path=.:img/

$(GRITH_PDF): $(GRITH_HTML)
	weasyprint "$(GRITH_HTML)" "$(GRITH_PDF)"

clean:
	rm -f "$(GRITH_PDF)" "$(GRITH_HTML)"
	rm -rf "$(OUT_DIR)/img" "$(OUT_DIR)/grith.css"
