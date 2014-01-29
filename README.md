Data Package
============

Library of classes and utilities for reading and writing data packages

[![Build Status](https://magnum.travis-ci.com/mode/data_package.png?token=i2TyUW8sMD41B46pRCpz&branch=master)](https://magnum.travis-ci.com/mode/data_package)
[![Code Climate](https://codeclimate.com/repos/52aba665c7f3a33617008a7a/badges/67d2bd79537542180840/gpa.png)](https://codeclimate.com/repos/52aba665c7f3a33617008a7a/feed)

## Installation

```
$ gem install data_package
```

## Opening and reading data packages

```
require 'data_package'

package = DataPackage::Package.open('path/to/package/dir')

puts package.name
puts package.version
puts package.resources
```

## This package currently supports data package specification v1.0-beta.8