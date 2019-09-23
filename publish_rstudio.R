knitr::write_bib(c(
  'bookdown', 'knitr', 'rmarkdown',
  'tidyverse', 'sjPlot', 'readxl',
  'ggplot2', 'car'
), 'packages.bib')

# Load xcolor instead of color for pdf
options(bookdown.post.latex = function(x) {
    stringr::str_replace(
        x,
        stringr::fixed("\\usepackage{color}"), 
        "\\usepackage[table,dvipsnames]{xcolor}"
    )
})

bookdown::clean_book(clean = TRUE)
bookdown::render_book("index.Rmd", output_format = "all")
bookdown::publish_book(
    name = "Rad",
    account = "####"
)