class Leaky
 class MyData
  def initialize(params)
   @params = params
  end	
 end
 
 LEAKING_ARRAY = {}
	
 def index(params)
  LEAKING_ARRAY[Time.now] = MyData.new(params)
 end
end
 
1000000.times { |i|
 a = Leaky.new
 a.index(i)
}
puts "Done"
sleep
