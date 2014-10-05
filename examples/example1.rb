class Foobar
end
 
hsh = {}
10000.times { |i| hsh[i] = Foobar.new }
 
puts "ready for analysis!"
sleep
