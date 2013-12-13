class BaseKlass
  include AttrHelper
  include AttrHelper::Serialization
  
  attr_required :name
  attr_optional :title
  attr_optional :format

  attr_required :data, :if => Proc.new{ |o| o.path.nil? && o.url.nil?  }
  attr_required :path, :if => Proc.new{ |o| o.data.nil? && o.url.nil?  }
  attr_required :url,  :if => Proc.new{ |o| o.data.nil? && o.path.nil? }

  attr_required :dialect, :if => :format_requires_dialect?

  attr_required :email, :unless => :empty_name?
  attr_required :web, :unless => Proc.new{ |o| o.name.nil? }

  def initialize(attrs = {})
    write_attributes(attrs)
  end

  def title=(value)
    write_attribute(:title, value + 'test')
  end

  def format_requires_dialect?
    format == 'csv'
  end

  def empty_name?
    name.nil?
  end
end

class ChildKlass < BaseKlass
  def title=(value)
    write_attribute(:title, value + 'child')
  end
end