# Primero incluye el Makefile común original
include ../../tools/Makefile.common

MD          := pj.md
AVENTURA_MD := oneshot.md
COMBAT_MD   := pj_combat.md
COMBAT_PDF  := $(OUT_DIR)/pj_combat.pdf
COMBAT_FILTER := $(TOOLS)/filters/page_per_h2.lua

.PHONY: combat clean-combat

combat: engine $(COMBAT_PDF)

$(COMBAT_PDF): $(COMBAT_MD) $(METADATA) $(COMBAT_FILTER) | $(OUT_DIR)
	$(PANDOC) "$(COMBAT_MD)" -o "$(COMBAT_PDF)" \
	  --from=markdown+smart \
	  --standalone \
	  --pdf-engine=$(PDF_ENGINE) \
	  --metadata-file=$(METADATA) \
	  --lua-filter=$(COMBAT_FILTER) \
	  --resource-path=.:img:pj/ \
	  $(ENGINE_FONT)

# Extiende clean para que también elimine el PDF de combate
clean: clean-combat

clean-combat:
	rm -f "$(COMBAT_PDF)"
