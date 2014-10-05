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
     printf "\nClass_id:%d\tClass_name:%s\tNumber_of_Objects:%d\tSize:%d\n\n",id,klass.name,entry1.objects,entry1.bytes					
     object = before.objects[id]
     cls1 = before.objects[id].as_module
     @instances = cls1.all_instances
     @instances.array.each do |i| 
      printf "  Object_id:%6d Bytes:%d\n",i.id, i.bytes
     end
     puts "#######################################################"
    end
   end
  end
 end
end

a = Display.new
