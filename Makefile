BUILD_DIR := gen

# pandoc is a handy tool for converting between numerous text formats:
# http://johnmacfarlane.net/pandoc/installing.html
PANDOC := pandoc

# pandoc options
# Liberation fonts: http://en.wikipedia.org/wiki/Liberation_fonts
PANDOC_PDF_OPTS := --toc --chapters --base-header-level=1 --number-sections --template=virsto_doc.tex --variable mainfont="Liberation Serif" --variable sansfont="Liberation Sans" --variable monofont="Liberation Mono" --variable fontsize=12pt --variable documentclass=book
PANDOC_EBOOK_OPTS := --toc --epub-stylesheet=epub.css --epub-cover-image=cover.jpg --base-header-level=1

# download kindlegen from http://www.amazon.com/gp/feature.html?ie=UTF8&docId=1000765211
KINDLEGEN := kindlegen
KINDLEGEN_OPTS :=

MARKDOWN := $(wildcard *.markdown)
PDF := $(patsubst %.markdown,$(BUILD_DIR)/%.pdf,$(MARKDOWN))
EBOOK := $(patsubst %.markdown,$(BUILD_DIR)/%.epub,$(MARKDOWN))
DOCX := $(patsubst %.markdown,$(BUILD_DIR)/%.docx,$(MARKDOWN))
WIKI := $(patsubst %.markdown,$(BUILD_DIR)/%.mediawiki,$(MARKDOWN))
HTML := $(patsubst %.markdown,$(BUILD_DIR)/%.html,$(MARKDOWN))

.PHONY: all checkdirs pdf ebook doc wiki html clean

all: checkdirs $(PDF) $(EBOOK) $(DOCX) $(WIKI) $(HTML)

checkdirs: $(BUILD_DIR)

pdf: checkdirs $(PDF)

ebook: checkdirs $(EBOOK)

doc: checkdirs $(DOCX)

wiki: checkdirs $(WIKI)

html: checkdirs $(HTML)

$(BUILD_DIR):
	@mkdir -p $@

# generate PDF
$(BUILD_DIR)/%.pdf: %.markdown
	$(PANDOC) $(PANDOC_PDF_OPTS) --self-contained -o $@ $<

# generate both iBooks (.epub) and then Kindle (.mobi) formats
$(BUILD_DIR)/%.epub: %.markdown
	$(PANDOC) $(PANDOC_EBOOK_OPTS) --self-contained -o $@ $<
	$(KINDLEGEN) $(KINDLEGEN_OPTS) $@ > /dev/null

# generate Microsoft Word documents (.docx)
$(BUILD_DIR)/%.docx: %.markdown
	$(PANDOC) --self-contained -o $@ $<

# generate files suitable for pasting into mediawiki
$(BUILD_DIR)/%.mediawiki: %.markdown
	$(PANDOC) -t mediawiki --self-contained -o $@ $<

# generate HTML files
$(BUILD_DIR)/%.html: %.markdown
	$(PANDOC) --self-contained -o $@ $<

clean:
	@rm -rf $(BUILD_DIR)
