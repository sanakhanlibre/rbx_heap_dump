require 'securerandom'
values = [] 
puts 'Leaking memory...'
1_000_000.times do
 values << SecureRandom.random_bytes(128)
end 
puts 'Done'
loop do
 sleep 1
end
