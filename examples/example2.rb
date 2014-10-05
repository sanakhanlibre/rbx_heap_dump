class Foo
end
 
ary = []
10000.times { ary << Foo.new }
 
puts "ready for analysis!"
sleep
