# Primero incluye el Makefile común original
include ../../tools/Makefile.common

GRITH_MD   := grith.md
GRITH_PDF  := $(OUT_DIR)/grith.pdf

.PHONY: grith clean-grith

grith: engine $(GRITH_PDF)

$(GRITH_PDF): $(GRITH_MD) $(METADATA) | $(OUT_DIR)
	$(PANDOC) "$(GRITH_MD)" -o "$(GRITH_PDF)" \
	  --from=markdown+smart \
	  --standalone \
	  --pdf-engine=$(PDF_ENGINE) \
	  --metadata-file=$(METADATA) \
	  --resource-path=.:img/ \
	  -V mainfont="DejaVu Sans"

# Extiende clean para que también elimine el PDF de Grith
clean: clean-grith

clean-grith:
	rm -f "$(GRITH_PDF)"
