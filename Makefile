
all: README.md

README.md: README.Rmd header.md
	Rscript -e "rmarkdown::render('$<')"
