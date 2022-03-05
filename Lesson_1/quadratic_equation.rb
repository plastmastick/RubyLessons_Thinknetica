puts "Программа для вычисления Квадратного уравнения"

puts "Укажите коэффициенты для вычисления уравнения:"
print "Коэффициент a: "
a = gets.chomp.to_i

print "Коэффициент b: "
b = gets.chomp.to_i

print "Коэффициент c: "
c = gets.chomp.to_i

discriminant = b**2 - 4*a*c

if discriminant < 0
  puts "Дискриминант = #{discriminant}. Корней нет!"
else
  x1 = (-b + Math.sqrt(discriminant)) / 2.0 * a
  if discriminant > 0
    x2 = (-b - Math.sqrt(discriminant)) / 2.0 * a
    puts "Дискриминант = #{discriminant}. Корни уравнения х1 = #{x1} и x2 = #{x2}"
  else
    puts "Дискриминант = #{discriminant}. Корень уравнения х = #{x1}"
  end
end
