butterfly 1.1.0 (yyyy-mm-dd)
=========================

### NEW FEATURES

  * Adding new `butterfly::timeline()` function, which checks if a time series is continuous. The user can specify the difference between timesteps expected (#24).
  * Adding new `butterfly::timeline_group()` function, which groups a time series in distinct, but continuous groups (#24).

### MINOR IMPROVEMENTS

  * Enabled further passing of `waldo` parameters (such as tolerance) (#18).
  * Improved CONTRIBUTING.md (#29).

butterfly 1.0.0 (2024-10-24)
=========================

### NEW FEATURES

* Initial release:

  * `butterfly::loupe()` - examines in detail whether previous values have changed, and returns TRUE/FALSE for no change/change.
  * `butterfly::catch()` - returns rows which contain previously changed values in a dataframe.
  * `butterfly::release()` - drops rows which contain previously changed values, and returns a dataframe containing new and unchanged rows.
  * `butterfly::create_object_list()` - returns a list of objects required by all of `loupe()`, `catch()` and `release()`. Contains underlying functionality.
  * `butterflycount` - a list of monthly dataframes, which contain fictional butterfly counts for a given date.
