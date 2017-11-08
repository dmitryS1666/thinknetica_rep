=begin
  Заполнить хеш гласными буквами, где значением будет являтся порядковый номер буквы в алфавите (a - 1).  
=end

array = []
vowels = %w(a e i o u)

('a'..'z').each do |char|
  if vowels.include?(char)
    array << char
  end
end

puts array