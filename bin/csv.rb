require 'heap_dump'

file = ARGV.shift
decoder = Rubinius::HeapDump.open(file)
histo = decoder.all_objects.histogram
printf "age,population\n"
histo.each_sorted do |klass, entry|
 printf "%s,%d\n", klass.name, entry.objects
end
