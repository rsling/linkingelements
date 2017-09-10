FIGUREDIR = figures
CACHEDIR = cache

pdf: leglossa.bbl leglossa.pdf 

all: pod cover

complete: index leglossa.pdf

index:  leglossa.snd
 
leglossa.pdf: leglossa.aux
	xelatex leglossa 

leglossa.aux: leglossa.tex $(wildcard local*.tex)
	xelatex -no-pdf leglossa 

# Before the XeTeX make begins, we need to make a TeX file from a Rnw file.
leglossa.tex: leglossa.Rnw $(wildcard sections/*.Rnw) $(wildcard sections/*.tex)
	Rscript \
	  -e "library(knitr)" \
	  -e "knitr::knit('$<','$@')"

# Make R files.
%.R: %.Rnw
	Rscript -e "Sweave('$^', driver=Rtangle())"

# Create only the book.
leglossa.bbl: leglossa.tex leglossa.bib  
	xelatex -no-pdf leglossa
	biber leglossa


leglossa.snd: leglossa.bbl
	touch leglossa.adx leglossa.sdx leglossa.ldx
	sed -i s/.*\\emph.*// leglossa.adx 
	sed -i 's/hyperindexformat{\\\(infn {[0-9]*\)}/\1/' leglossa.sdx
	sed -i 's/hyperindexformat{\\\(infn {[0-9]*\)}/\1/' leglossa.adx
	sed -i 's/hyperindexformat{\\\(infn {[0-9]*\)}/\1/' leglossa.ldx
# 	python3 fixindex.py
# 	mv mainmod.adx leglossa.adx
	makeindex -o leglossa.and leglossa.adx
	makeindex -o leglossa.lnd leglossa.ldx
	makeindex -o leglossa.snd leglossa.sdx 
	xelatex leglossa 
 

clean:
	rm -f leglossa.tex leglossa-concordance.tex *.bcf *.bak *~ *.backup *.tmp \
	*.adx *.and *.idx *.ind *.ldx *.lnd *.sdx *.snd *.rdx *.rnd *.wdx *.wnd \
	*.log *.blg *.ilg \
	*.aux *.toc *.cut *.out *.tpm *.bbl *-blx.bib *_tmp.bib \
	*.glg *.glo *.gls *.wrd *.wdv *.xdv *.mw *.clr \
	*.run.xml leglossa.tex leglossa.pgs leglossa.bcf \
	sections/*aux sections/*~ sections/*.bak sections/*.backup \
	langsci/*/*aux langsci/*/*~ langsci/*/*.bak langsci/*/*.backup \
	cache/* figures/* cache*.*
	
realclean: clean
	rm -f *.dvi *.ps *.pdf

FORCE:
