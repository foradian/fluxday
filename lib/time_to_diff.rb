require 'active_support/inflections'
module TimeExtenstions

  def max_diff
    if Time.now >= self
      delta = Time.now - self
      value = 0
      ['year', 'month', 'day', 'hour', 'minute', 'second'].each do |x|
        quo = delta.to_i / 1.send(x)
        value = quo.to_i.to_s+" "+x.pluralize(quo)+' ago' if (quo >= 1 && value == 0)
      end
      return value == 0 ? 'Just now' : value
    else
      return self.strftime('%d-%m-%Y %H:%M')
    end
  end
end

module DateExtenstions

  def to_quarters
    date = self
    qs = [[1, 2, 3], [4, 5, 6], [7, 8, 9], [10, 11, 12]] #qs - quarters
    q = qs[(date.month - 1) / 3] #q  - quarter
    unless q == [10, 11, 12]
      ["#{date.year}-#{q[0]}-1".to_date, ("#{date.year}-#{q[2]+1}-1".to_date - 1.days)]
    else
      ["#{date.year}-#{q[0]}-1".to_date, ("#{date.year}-#{12}-31".to_date)]
    end
  end
end

module IntExtenstions
  def to_duration
    return "#{self/60}:#{ '%02d' % (self%60)}"
  end
end

class Time
  include TimeExtenstions
end

class Date
  include DateExtenstions
end

class Fixnum
  include IntExtenstions
end
