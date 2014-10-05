require 'read_dump'

class Display
 def initialize
  file = ARGV.shift
  decoder = Rubinius::HeapDump::Decoder.new
  decoder.decode(file)
  histo = decoder.all_objects.histogram
  histo.each_sorted do |klass, entry|
   id = klass.id
   printf "id: %d class: %s\n",id,klass.name
   object = decoder.objects[id]
   cls1 = decoder.objects[id].as_module
   @instances = cls1.all_instances
   @instances.array.each do |i| 
    show_ref(i)
   end
   puts "-----------------------------------------------------------------"
   if id == 2256
    break
   end
  end
 end

 def show_object(obj)
  puts "in show_obj"
  cls = obj.class_object
  case cls.name
  when "Array"
   sz = obj["@total"]
   "#<Array id=#{obj.id} size=#{sz}>"
  when "String"
   total = obj["@num_bytes"]
   data = obj["@data"].data.data
   "#<String id=#{obj.id} bytes=#{total} #{data.inspect}>"
  else
   "#<#{obj.class_object.name} id=#{obj.id}>"
  end
 end

 def show_ref(ref)
  puts "in show ref"
  case ref
  when Rubinius::HeapDump::Reference
   puts "1"
   show_object sess.decoder.deref(ref)
  when Rubinius::HeapDump::XSymbol
   puts "2"
   "#<Symbol #{ref.data.inspect}>"
  when Array
   puts "3"
   ref.map { |x| x.inspect }.join(", ")
  else
   puts "4"
   puts ref.inspect
  end
 end
end

a = Display.new
