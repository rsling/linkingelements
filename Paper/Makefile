FIGUREDIR = figures
CACHEDIR = cache

all: lemorphology.pdf

lemorphology.pdf: lemorphology.tex $(wildcard local*.tex)
	pdflatex lemorphology
	bibtex lemorphology
	pdflatex lemorphology
	pdflatex lemorphology

# Before the XeTeX make begins, we need to make a TeX file from a Rnw file.
lemorphology.tex: lemorphology.Rnw $(wildcard sections/*.Rnw) $(wildcard sections/*.tex)
	Rscript \
	  -e "library(knitr)" \
	  -e "knitr::knit('$<','$@')"

# Make R files.
%.R: %.Rnw
	Rscript -e "Sweave('$^', driver=Rtangle())"

clean:
	rm -f lemorphology.tex lemorphology-concordance.tex *.bcf *.bak *~ *.backup *.tmp \
	*.adx *.and *.idx *.ind *.ldx *.lnd *.sdx *.snd *.rdx *.rnd *.wdx *.wnd \
	*.log *.blg *.ilg \
	*.aux *.toc *.cut *.out *.tpm *.bbl *-blx.bib *_tmp.bib \
	*.glg *.glo *.gls *.wrd *.wdv *.xdv *.mw *.clr \
	*.run.xml lemorphology.tex lemorphology.pgs lemorphology.bcf \
	sections/*aux sections/*~ sections/*.bak sections/*.backup \
	langsci/*/*aux langsci/*/*~ langsci/*/*.bak langsci/*/*.backup \
	cache/* figures/* cache*.*

realclean: clean
	rm -f *.dvi *.ps *.pdf

FORCE:
