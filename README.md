
<!-- README.md is generated from README.Rmd. Please edit that file -->

# swhidit

<!-- badges: start -->
<!-- badges: end -->

The goal of `swhidit` is to generate software references for R projects
using [Software Heritage Foundation Persistent
Identifiers](https://docs.softwareheritage.org/devel/swh-model/persistent-identifiers.html).

These can provide very fine-grained information about what software
packages are used, down to the commit and file hash level, that can be
key for replicating or auditing findings.

[knitcitations](https://github.com/cboettig/knitcitations) is also
useful, but typically generates citation entries for linked
documentation eg manuals, JSS articles rather than the software itself.

## Installation

*TODO*: You can install the released version of swhidit from
[CRAN](https://CRAN.R-project.org) with:

``` r
install.packages("swhidit")
```

You can install the development version of swhidit from
[GitHub](https://github.com/nfultz/swhidit) with:

``` r
remotes::install_github("nfultz/swhidit")
```

## Example

This is a basic example which shows you how to fetch SWHIDs for all
attached packages in your session:

``` r
library(swhidit)
library(jsonlite)
swhidit()
```

which generates a bibtex database:


    @softwareversion {cran:jsonlite,
      version = {1.7.2},
      author = {Jeroen Ooms [aut, cre] (<https://orcid.org/0000-0002-4035-0289>),
      Duncan Temple Lang [ctb],
      Lloyd Hilaiel [cph] (author of bundled libyajl)},
      title = {A Simple and Robust JSON Parser and Generator for R},
      date = {2020-12-09},
      swhid = {swh:1:dir:3f1184f03cd92cb96684e058d872e6d868a34584;
           origin=https://cran.r-project.org/package%3Djsonlite},
        url = {https://cran.r-project.org/package%3Djsonlite}
    }

which is then rendered using the appropriate tools:

# References

<div id="refs" class="references csl-bib-body hanging-indent">

<div id="ref-cran:jsonlite" class="csl-entry">

Jeroen Ooms \[aut, Duncan Temple Lang \[ctb\], cre\]
(&lt;https://orcid.org/0000-0002-4035-0289&gt;). 2020. “A Simple and
Robust JSON Parser and Generator for r.”
<https://cran.r-project.org/package%3Djsonlite>.

</div>

</div>
