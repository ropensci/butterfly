butterfly 1.1.2 (2025-04-04)
=========================
* Rephrased the DESCRIPTION description to avoid "This package" completely (#44).
* I have added British Antarctic Survey as "cph", as per the LICENSE (#44).

butterfly 1.1.1 (2025-04-02)
=========================
### DOCUMENTATION FIXES
* Adding rOpenSci Reviewers to DESCRIPTION.
* Updating URLs to match rOpenSci (#43).
* Adding rhub yaml (#43).
* Spelling checks in DESCRIPTION (#43).
* Elaborate package description in DESCRIPTION (#43).
* Changing @returns to @return to comply with tags check (#43)

butterfly 1.1.0 (2025-03-04)
=========================

### NEW FEATURES

  * Adding new `butterfly::timeline()` function, which checks if a time series is continuous. The user can specify the difference between timesteps expected (#24).
  * Adding new `butterfly::timeline_group()` function, which groups a time series in distinct, but continuous groups (#24).
  * Adding new `butterflymess` dataset, which provides a "messy" version of `butterflycount` for testing purposes (#33).

### MINOR IMPROVEMENTS

  * Enabled further passing of `waldo` parameters (such as tolerance) (#18).
  * Improved CONTRIBUTING.md (#29).
  * Adding further tests, using `butterflymess`, to test function response to badly formatted datasets (#33).
  * Improved `loupe()` feedback when there are no new rows (#34).
  
### DOCUMENTATION FIXES
  * Added section on contributing to `README` (#32).
  * Improved introduction of main vignette (#35).
  * Explicitly mentioned shell scripts are run in Bash (#35).
  * Improve description of what `loupe()` does (#36).
  * Elaborate on `all.equal()`, in addition to `waldo::compare()` (#36).
  * Fix error in `catch()` description, where it was mentioned the function uses `inner_join()`, when actually it uses `anti_join()` (#36).
  * Clarified `timeline()` description on how the expected lag units work for different periods of time (days, weeks) (#39).
  * Grammar and punctuation fixes (#35, #36).


butterfly 1.0.0 (2024-10-24)
=========================

### NEW FEATURES

* Initial release:

  * `butterfly::loupe()` - examines in detail whether previous values have changed, and returns TRUE/FALSE for no change/change.
  * `butterfly::catch()` - returns rows which contain previously changed values in a dataframe.
  * `butterfly::release()` - drops rows which contain previously changed values, and returns a dataframe containing new and unchanged rows.
  * `butterfly::create_object_list()` - returns a list of objects required by all of `loupe()`, `catch()` and `release()`. Contains underlying functionality.
  * `butterflycount` - a list of monthly dataframes, which contain fictional butterfly counts for a given date.
