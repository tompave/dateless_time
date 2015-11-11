# DatelessTime Changelog

## 1.0.0

The gem graduates from `0.0.x`. The basic functionality is stable and not going to change. The other additions that go into this release are small incremental changes.

#### New Features

* Added a changelog.  
* The method `#to_time` now also accepts `DateTime` objects as base values, in addition to `Time` and `Date`.  
* Added `#to_datetime` method, with semantics similar to `#to_time`.

#### Changes

* Small internal improvements.

## 0.0.4
#### New Features

* Added methos aliases for `hour`, `min` and `sec`, to make the interface more consistent with the default `Time` class.  
* The method `#to_time` now also accepts `Date` objects as base values, in addition to `Time` objects.

## 0.0.3
#### New Features

* Added support to initialize new `DatelessTime` objects with other existing `DatelessTime` objects as sources.  
* Added support to initizlize new `DatelessTime` objects with `DateTime` objects as sources.  
* Offical support for sorting in arrays (just added tests to make sure it works).  

#### Changes

* The gem now explicitly requires `date` from the standard library.

#### Bug Fixes

* Inizializing `DatelessTime` objects with strings like `"12:01 am"` or `"12:01 pm"` was generating invalid data.

## 0.0.2

#### New Features

* Implemented support for the `Comparable` module. `DatelessTime` objects now support comparison operators: `==`, `<`, etc.

#### Bug Fixes

* The return value of `#to_time` was memoized, this made it impossible to use it moltiple times with different base values.

## 0.0.1

The initial release.
