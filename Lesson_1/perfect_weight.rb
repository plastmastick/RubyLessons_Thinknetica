puts "Программа для определения идеального веса."

puts "Укажите Ваше имя:"
user_name = gets.chomp.capitalize!

puts "#{user_name}, укажите Ваш рост:"
user_height = gets.chomp.to_i

user_weight = (user_height - 110) * 1.15

#Проверка веса
if user_weight >= 0
  puts "#{user_name}, Ваш вес уже оптимальный."
else puts "#{user_name}, Ваш вес не оптимальный."
end
