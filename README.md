# sync-async-manuscript

Notes:

- this should work best if you clone / download the repository and then open the R project (will make it easier to find the correct file paths)
- analysis.Rmd is the main file to run
  - it contains sections associated with each of the research questions
  - right now, it renders to HTML, but we can render it to a PDF or Word Doc if we like
- there is one tricky dependency - it's a package for tidy *t*-tests Josh made for this
  - you have to first install the **devtools** package and then use devtools to download **tidyttest** from GitHub (it's not available on CRAN)
- analysis.R is the old script - it is not used for the manuscript 
