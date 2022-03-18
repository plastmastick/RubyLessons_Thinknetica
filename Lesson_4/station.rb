class Station
  attr_reader :name, :trains

  def initialize(name)
    @name = name
    @trains = []
  end

  def show_trains_by_type(train_type)
    trains_by_type = []
    @trains.each { |train| trains_by_type << train if train.type == train_type}
  end

  def add_train(train)
    @trains << train if !@trains.include?(train) && train.current_station == self
  end

  def send_train(train, forward)
    if @trains.include?(train) && train.current_station == self
      train.next_station if forward
      train.previous_station if !forward
      self.delete_train(train)
    else
      self.delete_train(train)
    end
  end

  private

  #Нет подклассов. Поезд не должен удалять сам себя, т.к. отправкой занимается станция
  def delete_train(train)
    @trains.delete(train) if @trains.include?(train) && train.current_station != self
  end
end
