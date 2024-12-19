# Add in? method, so we can do x.in?(array) instead of array.include?(x)
class Object
  def in?(collection)
    collection.include?(self)
  end
end

# Decorator to memoize the result of a given function
def memoize(fn)
  cache = {}
  fxn = singleton_class.instance_method(fn)
  define_singleton_method fn do |*args|
    unless cache.include?(args)
      cache[args] = fxn.bind(self).call(*args)
    end
    cache[args]
  end
end
