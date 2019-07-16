knitr::write_bib(c(
  .packages(), 'bookdown', 'knitr', 'rmarkdown'
), 'packages.bib')
bookdown::render_book("index.Rmd", output_format = "bookdown::gitbook")
bookdown::publish_book(
    name = "Rad",
    account = "####"
)