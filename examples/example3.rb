class Foo
 def initialize(y)
  @yak = y
 end
end
 
ary = []
10000.times { |i| ary << Foo.new(i) }
 
puts "ready for analysis!"
sleep
