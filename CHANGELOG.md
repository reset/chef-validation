# 0.2.3

* Enhancements
  * Use Chef Gem compile_time option when available

# 0.2.2

* Bug Fixes
  * Allow `optional` and `recommended` to be passed in for `required` attribute rule
  * Display name of cookbook in error when cookbook not in run list

# 0.2.1

* Bug Fixes
  * Don't treat 'false' as a missing required attribute

# 0.2.0

* Enhancements
  * Validations will not be run for attributes who are dependent upon recipes when those recipes are not in the expanded run list of the node.

# 0.1.6

* Bug Fixes
  * Required attribute validations will once again pass if they have values present

# 0.1.5

* Bug Fixes
  * Fix issue with running boolean type validations on Ruby 1.9 series

# 0.1.4

* Bug Fixes
  * Fix issue with validating non-string required attributes

# 0.1.3

* Bug Fixes
  * Fix issue on some versions of Chef where metadata would not be properly loaded at different points of the Chef run
  * Fix crash when a value is `nil` and checking for it's presence

# 0.1.2

* Enhancements
  * Loosen constraint on Chef to allow for any version of Chef from the 11 & 12 series.

# 0.1.1

* Bug Fixes
  * 0.1.0 cookbook package was uploaded incorrectly, sigh.

# 0.1.0

Initial release of validation
