=begin
  Заполнить массив числами фибоначчи до 100
  0 1 1 2 3 5 8 13 21 34 35 55 89 | 144
  E(n) = E(n-1) + E(n-2), n >= 2
=end

array = [0]

x = 1
y = 1

(1..100).each do |i|
  if i <= 2
    array << 1
  else
    temp = x + y
    x = y
    y = temp
    array << temp if temp <= 100
  end
end

puts array
