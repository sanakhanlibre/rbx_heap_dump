require 'read_dump'
require 'heap_dump/histogram'

class Display
 def initialize
  file = ARGV.shift
  after_file = ARGV.shift
		
  before = Rubinius::HeapDump::Decoder.new
  before.decode(file)

  after = Rubinius::HeapDump::Decoder.new
  after.decode(after_file)
		
  b = get_class_name_id before.all_objects.array
  a = get_class_name_id after.all_objects.array
  c = {}
		
  a.each do |k,e|
   if prev = b[k]
    n = e - prev
    if n.objects != 0
     c[k] = n
    end
   end
  end

  c.each do |name,entry|
   if entry.bytes > 0
    id = $id_hsh[name]
    printf "\nClass_id:%d\tClass_name:%s\tNumber_of_Objects:%d\tSize:%d\n\n",id,name,entry.objects,entry.bytes				
    object = before.objects[id]
    cls1 = before.objects[id].as_module
    instances = cls1.all_instances
    my_array = []
    count = Hash.new(0)	
    instances.array.each do |i| 
     my_array.push(i.bytes) unless my_array.include?(i.bytes)
     count[i.bytes] += 1
    end
    count.each do |b, num|
     percentage = b*num*100/entry.bytes
     printf "%6d Objects [%f Percent] occupy %d bytes each\n",num,percentage,b
    end
    puts "#######################################################"	
   end
  end
 end

 def get_class_name_id(objects)
  histogram = Hash.new { |h,k| h[k] = Rubinius::HeapDump::Histogram::Entry.new(k) }
  $id_hsh = Hash.new(0)

  objects.each do |o|
   klass = o.class_object
   if n = klass.name
    histogram[n].inc(o)
    unless $id_hsh.include?(n)
     $id_hsh[n]=klass.id
    end
   end
  end
  return Rubinius::HeapDump::Histogram.new(histogram)
 end
end

a = Display.new
