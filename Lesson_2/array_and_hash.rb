# Первое задание
puts "Вывести месяца, где кол-во дней ровно 30: \n"

mounth_day_count = {
  Январь: 31,
  Февраль: 28,
  Март: 31,
  Апрель: 30,
  Май: 31,
  Июнь: 30,
  Июль: 31,
  Август: 31,
  Сентябрь: 30,
  Октябрь: 31,
  Ноябрь: 30,
  Декабрь: 31
}

mounth_day_count.each { |mounth,day| print "#{mounth}; " if day == 30 }

#Второе задание
puts "\n \nЗаполнить массив числами от 10 до 100 с шагом 5:"

task = []
i = 10

while i <= 100 do
  task << i
  i += 5
end

puts "#{task}"

#Третье задание
puts "\nЗаполнить массив числами фибоначчи до 100:"

fibonacci = [0, 1]
current_value = 0

while current_value <= 100 do
  current_value = fibonacci[fibonacci.length - 1] + fibonacci[fibonacci.length - 2]
  if current_value <= 100
    fibonacci << current_value
  else
    break
  end
end

puts "#{fibonacci}"

#Четвертое задание
puts "\nЗаполнить хеш гласными буквами, где значением будет являтся порядковый номер буквы в алфавите"

vowels_alp = {}
vowels = ["a", "e", "i", "o", "u"]
num = 0

("a".."z").each do |letter|
  num += 1
  vowels_alp[letter.to_sym] = num if vowels.include?(letter)
end

puts vowels_alp
