Data Package
============

Library of classes and utilities for reading and writing data packages

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