knitr::write_bib(c(
  .packages(), 'bookdown', 'knitr', 'rmarkdown'
), 'packages.bib')

# Load xcolor instead of color for pdf
options(bookdown.post.latex = function(x) {
    stringr::str_replace(
        x,
        stringr::fixed("\\usepackage{color}"), 
        "\\usepackage[table,dvipsnames]{xcolor}"
    )
})

bookdown::render_book("index.Rmd", output_format = "all")
bookdown::publish_book(
    name = "Rad",
    account = "####"
)