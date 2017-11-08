=begin
  Заполнить массив числами от 10 до 100 с шагом 
=end

array=[]

(10..100).step(5) do |i|
  array << i
end

puts array