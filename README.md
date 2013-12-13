Data Package
============

Library of classes and utilities for reading and writing data packages

### Attribute Helpers

#### Usage

attr_required :name
attr_required :path, :if => lamda {|obj|
  obj.attr_missing?(:url) && obj.attr_missing?(:data)
}

attr_optional :title
attr_optional :sources, :default => [], :key => 'sources',
  :serialize => lambda { |source| source.collect(&:to_hash) }

key is not required for attr_optional as it defaults to name of the attribute

#### Instance Methods

required_attrs => [...]
optional_attrs => [...]
serializable_attrs => [...]

attr_required?(attr_name) #=> boolean

valid? #=> boolean, Are all required fields present?

attr_missing?(attr_name) #=> boolean
attr_present?(attr_name) #=> boolean