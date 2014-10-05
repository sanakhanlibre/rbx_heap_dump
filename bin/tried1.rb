require 'read_dump'

file = ARGV.shift

decoder = Rubinius::HeapDump::Decoder.new
decoder.decode(file)

def show_object(obj)
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
	
histo = decoder.all_objects.histogram
histo.each_sorted do |klass, entry|
 id = klass.id
 session = HeapDumpSession.session
 object = session.decoder.objects[id]
 cls1 = session.decoder.objects[id].as_module
 instances = cls1.all_instances
 #works -- puts instances.class -- Rubinius::HeapDump::Objects
	
 instances.array.each do |ref| 
  case ref
  when Rubinius::HeapDump::Reference
   show_object session.decoder.deref(ref)
  when Rubinius::HeapDump::XSymbol
   puts " Symbol #{ref.data.inspect} "
  when Array
   puts ref.map { |x| x.inspect }.join(", ")
  else
   puts ref.inspect
  end
 end
end
