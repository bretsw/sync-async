# Sync-Async Manuscript

Note that the dataset has been preprocessed using the R package **rtweet** to collect full Twitter API-supported metadata for tweets initially collected using **TAGS**. Furthermore, the content of these tweets has been analyzed with the proprietary (i.e., not open) LIWC software and has been processed to remove identifiable information.

- `analysis.Rmd` is the main file to run
  - This file contains sections associated with each of the research questions.
  - Currently, this file renders to HTML, but you can render it to a PDF or Word Doc if you prefer.
- Note that there are two tricky dependencies:
  - You will first need to install the **devtools** package
  - Next, use devtools to download the **tidyttest** package from GitHub (it's not available on CRAN). This is a package for tidy *t*-tests.
  - Finally, use devtools to dowload the **OSFR** package from GitHub. This is a package to import the dataset from OSF.io.
- No data is shared on GitHub; you will need to add the file `sync-async-dataset.csv` manually to this repository OR follow the instructions to import the file from OSF.io.
  - The data is "ignored" by the `.gitignore` file; you can double-check that yours ignores these files, too, in the case that you push changes, but it should copy over when you clone/download the repository.
- Open `analysis.html` to view the completed analysis.