require 'read_dump'

file = ARGV.shift

decoder = Rubinius::HeapDump::Decoder.new
decoder.decode(file)

histo = decoder.all_objects.histogram
histo.each_sorted do |klass, entry|
 id = klass.id
 printf "id: %d class: %s\n",id,klass.name
 object = decoder.objects[id]
 cls1 = decoder.objects[id].as_module
 instances = cls1.all_instances
 instances.array.each do |i| 
  puts i
 end
 puts "------------------------------------------------------------------"
end
