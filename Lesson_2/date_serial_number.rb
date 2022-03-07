puts "Определение порядкового номера даты."

date = 0
mounth = 0
year = 0

#Запрашиваем данные у пользователя
loop do
  print "\n1) Введите число: "
  date = gets.chomp.to_i
  break if (1..31).include?(date)
  puts "Некорректное число!"
end

loop do
  print "\n2) Введите месяц: "
  mounth = gets.chomp.to_i
  break if (1..12).include?(mounth)
  puts "Некорректный месяц!"
end

loop do
  print "\n3) Введите год: "
  year = gets.chomp.to_i
  break if year > 0
  puts "Некорректный год!"
end

#Проверка на високосный год
if (year % 100 == 0 && year % 400 == 0) || (year % 4 == 0 && year % 100 != 0)
  is_leap_year = true
else
  is_leap_year = false
end

mounth_day_count = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
mounth_day_count[1] += 1 if is_leap_year

#Определение порядкового номера даты
current_day_num = 0
mounth_num = 1

mounth_day_count.each do |count|
  if mounth_num == mounth
    current_day_num += date
    break
  else
    current_day_num += count
  end
  mounth_num += 1
end

puts "\nПорядковый номер даты в году: #{current_day_num}"
