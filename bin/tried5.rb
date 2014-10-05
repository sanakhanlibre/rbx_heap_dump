require 'read_dump'
require 'heap_dump/diff'

class Display
 def initialize
  file = ARGV.shift
  after_file = ARGV.shift
		
  before = Rubinius::HeapDump::Decoder.new
  before.decode(file)

  after = Rubinius::HeapDump::Decoder.new
  after.decode(after_file)

  histo1 = before.all_objects.histogram
  diff = Rubinius::HeapDump::Diff.new(before, after)
  histo2 = diff.histogram
		
  histo1.each_sorted do |klass, entry1|
   id = klass.id
   histo2.each_sorted do |name, entry2|
    if klass.name == name && entry2.bytes > 0
     printf "id: %d class: %s\n",id,name
     object = before.objects[id]
     cls1 = before.objects[id].as_module
     @instances = cls1.all_instances
     @instances.array.each do |i| 
      puts i.inspect
     end
     puts "-----------------------------------------------------------------"
    end
   end
  end
 end
end
a = Display.new
