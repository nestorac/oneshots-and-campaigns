# Primero incluye el Makefile común original
include ../../tools/Makefile.common

GRITH_MD   := grith.md
GRITH_TYP  := grith.typ
GRITH_PDF  := $(OUT_DIR)/grith.pdf

# Objetivo por defecto: solo grith (Typst)
.DEFAULT_GOAL := grith

.PHONY: grith clean all

# Evita que all intente generar pj y aventura
all: grith

grith: $(GRITH_PDF)

$(GRITH_PDF): $(GRITH_TYP) | $(OUT_DIR)
	typst compile "$(GRITH_TYP)" "$(GRITH_PDF)"

# Sobrescribe clean para que solo elimine el PDF de este directorio
clean:
	rm -f "$(GRITH_PDF)"
