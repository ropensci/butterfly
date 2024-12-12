# Contributing to butterfly
We warmly welcome and actively encourage community contributions. This package was created with particular use cases in mind, and while an effort was made to generalise functionality, it may not work for every scenario. Further perspectives and applications will improve this package. 

## With write access
You can push directly to main for small fixes. Please use PRs to main for discussing larger updates.

## Without write access
Corrections, suggestions and general improvements are welcome as [issues](https://github.com/antarctica/butterfly/issues).

You can also suggest changes by forking this repository, and opening a pull request. Please target your pull requests to the main branch.

If you’ve found a bug, please file an issue that illustrates the bug with a minimal 
reprex(this will also help you write a unit test, if needed). See the tidyverse guidance on [how to create a great issue](https://code-review.tidyverse.org/issues/) for more advice.

### Pull request process

* Fork the package and clone onto your computer. If you haven't done this before, we recommend using `usethis::create_from_github("antarctica/butterfly", fork = TRUE)`.

* Install all development dependencies with `devtools::install_dev_deps()`, and then make sure the package
passes R CMD check by running `devtools::check()`. If R CMD check doesn't pass cleanly, it's a good idea to ask for help before continuing. 

* Create a Git branch for your pull request (PR). We recommend using `usethis::pr_init("brief-description-of-change")`.

* Make your changes, commit to git, and then create a PR by running `usethis::pr_push()`, and following the prompts in your browser. The title of your PR should briefly describe the change. The body of your PR should contain `Fixes #issue-number`.

* We use [testthat](https://cran.r-project.org/package=testthat) for unit tests. If you create new functionality, or change existing functionality, please make sure all functionality is covered by tests, run `covr::package_coverage()` to check this.

* New code should follow the tidyverse [style guide](https://style.tidyverse.org). You can use the [styler](https://CRAN.R-project.org/package=styler) package to apply these styles, but please don't restyle code that has nothing to do with your PR.  

*  For user-facing changes, add a bullet to the top of `NEWS.md` (i.e. just below the first header). Follow the style described in <https://devguide.ropensci.org/maintenance_releases.html#news>.

*  Before requesting a review, please make sure you have run `covr::package_coverage()`, `devtools::check()` and `pkgcheck::pkgcheck()`, as well as `devtools::build_readme`, `devtools::document()`, `devtools::build_vignettes()` or `devtools::build_site()` if you have made any changes to the README, documentation, vignettes or site.

* We follow the rOpenSci guidance on [contributor attributions](https://devguide.ropensci.org/maintenance_collaboration.html#attributions). Please feel free to add yourself to the `Authors@R` field of the [`DESCRIPTION`](https://github.com/ropensci/targets/blob/main/DESCRIPTION) file, and specify your role (e.g. "ctb" for small contributions or "aut" for bigger contributions).

## Code of Conduct

Please note that the butterfly project is released with a
[Contributor Code of Conduct](CODE_OF_CONDUCT.md). By contributing to this
project you agree to abide by its terms.
