puts "Программа для определения типа треугольнка."

puts "Укажите стороны треугольника:"
print "Первая сторона: "
a = gets.chomp.to_i

print "Вторая сторона: "
b = gets.chomp.to_i

print "Третья сторона: "
c = gets.chomp.to_i

# определение гипотенузы
if a > b && a > c
  rectangular_check = (c**2 + b**2) == a**2
elsif b > a && b > c
  rectangular_check = (a**2 + c**2) == b**2
else
  rectangular_check = (a**2 + b**2) == c**2
end

#Тип треугольника
if rectangular_check
  puts "Заданный треугольник - прямоугольный"
elsif a == b && a == c && b == c
  puts "Заданный треугольник - равносторонний"
else a == b || a == c || b == c
  puts "Заданный треугольник - равнобедренный"
end
