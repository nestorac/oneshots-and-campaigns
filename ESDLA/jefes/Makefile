# Primero incluye el Makefile común original
include ../../tools/Makefile.common

GRITH_MD   := grith.md
GRITH_PDF  := $(OUT_DIR)/grith.pdf

# Objetivo por defecto: solo grith
.DEFAULT_GOAL := grith

.PHONY: grith clean all

# Evita que all intente generar pj y aventura
all: grith

grith: engine $(GRITH_PDF)

$(GRITH_PDF): $(GRITH_MD) $(METADATA) | $(OUT_DIR)
	$(PANDOC) "$(GRITH_MD)" -o "$(GRITH_PDF)" \
	  --from=markdown+smart \
	  --standalone \
	  --pdf-engine=$(PDF_ENGINE) \
	  --metadata-file=$(METADATA) \
	  --lua-filter=$(TOOLS_DIR)/filters/sideimage.lua \
	  --resource-path=.:img/ \
	  -V mainfont="DejaVu Sans" \
	  -V header-includes="\\usepackage{graphicx}\\usepackage{wrapfig}\\setlength{\\intextsep}{2pt}\\setlength{\\columnsep}{10pt}"

# Sobrescribe clean para que solo elimine el PDF de este directorio
clean:
	rm -f "$(GRITH_PDF)"
