# Production defaults: LuaLaTeX + BibLaTeX/Biber.
$pdf_mode = 4;
$out_dir = 'build';
$aux_dir = 'build';
$max_repeat = 5;

$lualatex = 'lualatex -interaction=nonstopmode -file-line-error -halt-on-error -synctex=1 %O %S';
$xelatex = 'xelatex -interaction=nonstopmode -file-line-error -halt-on-error -synctex=1 %O %S';
$pdflatex = 'pdflatex -interaction=nonstopmode -file-line-error -halt-on-error -synctex=1 %O %S';
$biber = 'biber %O %B';
$bibtex = 'bibtex %O %B';
