puts "Программа вычисления площади треугольника."

puts "Укажите значение для основания треугольника:"
triangle_base = gets.chomp.to_i

puts "Укажите значение для высоты треугольника:"
triangle_height = gets.chomp.to_i

triangle_square = 1.0 / 2.0 * triangle_base * triangle_height
puts "Площадь заданного треугольника: #{triangle_square}"
