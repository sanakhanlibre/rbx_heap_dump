require 'read_dump'

file = ARGV.shift

decoder = Rubinius::HeapDump::Decoder.new
decoder.decode(file)
histo = decoder.all_objects.histogram
histo.each_sorted do |klass, entry|
 id = klass.id
 printf "\nid: %d class: %s",id,klass.name
end
