LX = xelatex
MI = makeindex
BX = biber

FILEN = linkingelements
TEXFLAGS =

once:
	-$(LX) $(TEXFLAGS) $(FILEN) | grep 'Warning\|Error'

quick:
	-$(LX) $(TEXFLAGS) $(PREFLAGS) $(FILEN)
	printf "\033c"
	@echo
	@echo " === LAST RUN === "
	@echo
	-$(LX) $(TEXFLAGS) $(FILEN) | grep 'Warning'

clean:
	\rm *.adx *.and *.aux *.bbl *.blg *.idx *.ilg *.ldx *.lnd *.log *.out *.pdf *.rdx *.run.xml *.sdx *.snd *.toc *.wdx *.xdv *.bcf

all:
	-$(LX) $(TEXFLAGS) $(PREFLAGS) $(FILEN)
	-$(BX) $(FILEN)
	-$(LX) $(TEXFLAGS) $(PREFLAGS) $(FILEN)
	printf "\033c"
	@echo
	@echo " === LAST RUN === "
	@echo
	-$(LX) $(TEXFLAGS) $(FILEN) | grep 'Warning\|Error'

view:
	open $(FILEN).pdf & 

edit:
	mvim -c ':set spell spelllang=en' -c ':nnoremap <F15> ]s' -c ':nnoremap <F14> [s' $(FILEN).tex
