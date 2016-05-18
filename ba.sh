#!/bin/bash
sudo apt-get install tipa xfonts-tipa
sudo apt-get install texlive-fonts-recommended
sudo apt-get install texlive-lang-french
wget http://mirrors.ctan.org/macros/latex/contrib/fncychap/fncychap.sty
wget http://mirrors.ctan.org/macros/latex/contrib/multirow/multirow.sty
wget http://mirrors.ctan.org/fonts/tipa/tipa/sty/tipa.sty
wget http://tug.ctan.org/fonts/tipa/tipa/sty/t3enc.def
wget http://www.cs.cmu.edu/afs/cs/misc/tex/common/teTeX-1.0/lib/texmf/tex/latex/misc/soul.sty
wget http://web.mit.edu/jhawk/mnt/spo/tex/share/texmf/tex/latex/misc/moreverb.sty
wget http://mirrors.ctan.org/macros/latex/contrib/titlesec/titlesec.sty
wget http://mirrors.ctan.org/biblio/bibtex/contrib/bib-fr/plain-fr.bst
wget http://mirrors.ctan.org/macros/latex/contrib/enumitem/enumitem.sty
wget http://mirrors.ctan.org/macros/latex/contrib/epigraph.zip
mkdir outpp
unzip -x epigraph.zip -d outpp
cd outpp/epigraph
latex epigraph.ins
cp epigraph.sty ../../
cd ../../
rm -rf outpp
rm -rf epigraph.zip