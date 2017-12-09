FIGUREDIR = figures
CACHEDIR = cache

pdf: lemorphology.bbl lemorphology.pdf

complete: lemorphology.pdf

lemorphology_biber.bib: lemorphology.bcf
	biber lemorphology --output_format bibtex

lemorphology.pdf: lemorphology.aux
	pdflatex lemorphology
	pdflatex lemorphology

lemorphology.aux: lemorphology.tex $(wildcard local*.tex)
	pdflatex lemorphology

# Before the XeTeX make begins, we need to make a TeX file from a Rnw file.
lemorphology.tex: lemorphology.Rnw $(wildcard sections/*.Rnw) $(wildcard sections/*.tex)
	Rscript \
	  -e "library(knitr)" \
	  -e "knitr::knit('$<','$@')"

# Make R files.
%.R: %.Rnw
	Rscript -e "Sweave('$^', driver=Rtangle())"

# Create bibtex file.
lemorphology.bbl: lemorphology.tex
	pdflatex lemorphology
	bibtex lemorphology

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
