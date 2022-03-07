puts "Определение суммы покупок в корзине."

user_basket = Hash.new("Товар не найден")

#Запрашиваем список покупок у пользователя
puts "\nВведите поочередно название товара, цену за единицу и кол-во купленного товара.\nДля завершения введите 'CТОП' в названии товара.\n________"

product_num = 0

loop do
  puts "\nТовар №#{product_num += 1}"
  product_name = ""
  product_count = 0
  product_price = 0

  loop do
    print "\nВведите название товара: "
    product_name = gets.chomp
    break if product_name != ""
    puts "Некорректное значение!"
  end

  break if product_name.downcase == "стоп"

  loop do
    print "Введите цену товара: "
    product_price = gets.chomp.to_f
    break if product_price >= 0
    puts "Некорректное значение!"
  end

  loop do
    print "Введите количество товара: "
    product_count = gets.chomp.to_f
    break if product_count > 0
    puts "Некорректное значение!"
  end

  user_basket[product_name.to_sym] = {price: product_price, count: product_count}
end

#Вывод корзины пользователя
puts "\n________\nКорзина с покупками."

product_num = 0
basket_total_cost = 0

user_basket.each do |name, param|
  full_cost = 0
  price = 0
  count = 0
  param.each do |key, value|      #Запись хэша товара
    if key == :price
      price = value
    elsif key == :count
      count = value
    else
      puts "Неизвестный ключ!"
    end
  end
  full_cost = price * count
  puts "\n№#{product_num += 1}\nТовар: #{name.capitalize}\nЦена: #{price}\nКоличество: #{count}\nИтоговая цена: #{full_cost}"
  basket_total_cost += full_cost
end

puts "\n________\nИтоговая цена за все товары в корзине: #{basket_total_cost}"
