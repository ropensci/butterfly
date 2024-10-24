# butterfly 1.0.0

* Initial release:

  * `butterfly::loupe()` - examines in detail whether previous values have changed, and returns TRUE/FALSE for no change/change.
  * `butterfly::catch()` - returns rows which contain previously changed values in a dataframe.
  * `butterfly::release()` - drops rows which contain previously changed values, and returns a dataframe containing new and unchanged rows.
  * `butterfly::create_object_list()` - returns a list of objects required by all of `loupe()`, `catch()` and `release()`. Contains underlying functionality.
  * `butterflycount` - a list of monthly dataframes, which contain fictional butterfly counts for a given date.
