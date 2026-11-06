# Makefile — AI-asistovaný vývoj
# Vyžaduje: lualatex + latexmk (TeX Live 2026+, kvůli tagovanému PDF/UA-2).
# latexmk opakuje běhy, dokud se neustálí TOC, \pageref{LastPage} a odkazy
# (s tagováním to bývají tři běhy, ne dva).
# Dva dokumenty sdílející preamble.tex:
#   ai-rules  — hlavní pravidla
#   motivace  — doprovodný motivační text
# Anglická varianta je v podsložce en/ (vlastní preamble.tex — jazyk, uvozovky):
#   ai-rules    — hlavní pravidla
#   motivation  — doprovodný motivační text (protějšek motivace.tex)
# Buduje se z adresáře en/, aby \input{preamble.tex} trefil anglickou preambuli.

LATEXMK = latexmk -lualatex
FLAGS   = -interaction=nonstopmode -halt-on-error
DOCS    = ai-rules motivace
EN_DIR  = en
EN_NAMES = ai-rules motivation
EN_DOCS = $(addprefix $(EN_DIR)/,$(EN_NAMES))

.PHONY: all cs en clean distclean watch

all: cs en

# Česká (výchozí) varianta v kořeni
cs: ai-rules.pdf motivace.pdf

# Anglická varianta v en/
en: $(addsuffix .pdf,$(EN_DOCS))

ai-rules.pdf: ai-rules.tex preamble.tex
	$(LATEXMK) $(FLAGS) ai-rules.tex

motivace.pdf: motivace.tex preamble.tex
	$(LATEXMK) $(FLAGS) motivace.tex

$(EN_DIR)/ai-rules.pdf: $(EN_DIR)/ai-rules.tex $(EN_DIR)/preamble.tex
	cd $(EN_DIR) && $(LATEXMK) $(FLAGS) ai-rules.tex

$(EN_DIR)/motivation.pdf: $(EN_DIR)/motivation.tex $(EN_DIR)/preamble.tex
	cd $(EN_DIR) && $(LATEXMK) $(FLAGS) motivation.tex

# Průběžný build hlavního dokumentu
watch:
	$(LATEXMK) -interaction=nonstopmode -pvc ai-rules.tex

clean:
	rm -f $(addsuffix .aux,$(DOCS) $(EN_DOCS)) $(addsuffix .log,$(DOCS) $(EN_DOCS)) \
	      $(addsuffix .out,$(DOCS) $(EN_DOCS)) $(addsuffix .toc,$(DOCS) $(EN_DOCS)) \
	      $(addsuffix .fls,$(DOCS) $(EN_DOCS)) $(addsuffix .fdb_latexmk,$(DOCS) $(EN_DOCS))

distclean: clean
	rm -f $(addsuffix .pdf,$(DOCS) $(EN_DOCS))
