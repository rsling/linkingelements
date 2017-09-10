FIGUREDIR = figures
CACHEDIR = cache

pdf: linkingelements.bbl linkingelements.pdf 

all: pod cover

complete: index linkingelements.pdf

index:  linkingelements.snd
 
linkingelements.pdf: linkingelements.aux
	xelatex linkingelements 

linkingelements.aux: linkingelements.tex $(wildcard local*.tex)
	xelatex -no-pdf linkingelements 

# Before the XeTeX make begins, we need to make a TeX file from a Rnw file.
linkingelements.tex: linkingelements.Rnw $(wildcard sections/*.Rnw) $(wildcard sections/*.tex)
	Rscript \
	  -e "library(knitr)" \
	  -e "knitr::knit('$<','$@')"

# Make R files.
%.R: %.Rnw
	Rscript -e "Sweave('$^', driver=Rtangle())"

# Create only the book.
linkingelements.bbl: linkingelements.tex linkingelements.bib  
	xelatex -no-pdf linkingelements
	biber linkingelements


linkingelements.snd: linkingelements.bbl
	touch linkingelements.adx linkingelements.sdx linkingelements.ldx
	sed -i s/.*\\emph.*// linkingelements.adx 
	sed -i 's/hyperindexformat{\\\(infn {[0-9]*\)}/\1/' linkingelements.sdx
	sed -i 's/hyperindexformat{\\\(infn {[0-9]*\)}/\1/' linkingelements.adx
	sed -i 's/hyperindexformat{\\\(infn {[0-9]*\)}/\1/' linkingelements.ldx
# 	python3 fixindex.py
# 	mv mainmod.adx linkingelements.adx
	makeindex -o linkingelements.and linkingelements.adx
	makeindex -o linkingelements.lnd linkingelements.ldx
	makeindex -o linkingelements.snd linkingelements.sdx 
	xelatex linkingelements 
 

clean:
	rm -f *.bak *~ *.backup *.tmp \
	*.adx *.and *.idx *.ind *.ldx *.lnd *.sdx *.snd *.rdx *.rnd *.wdx *.wnd \
	*.log *.blg *.ilg \
	*.aux *.toc *.cut *.out *.tpm *.bbl *-blx.bib *_tmp.bib \
	*.glg *.glo *.gls *.wrd *.wdv *.xdv *.mw *.clr \
	*.run.xml linkingelements.tex linkingelements.pgs linkingelements.bcf \
	sections/*aux sections/*~ sections/*.bak sections/*.backup \
	langsci/*/*aux langsci/*/*~ langsci/*/*.bak langsci/*/*.backup \
	cache/* figures/* cache*.*
	
realclean: clean
	rm -f *.dvi *.ps *.pdf

FORCE:
