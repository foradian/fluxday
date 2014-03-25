require 'active_support/inflections'
module TimeDifference

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
  #def time_ago
  #  delta = Time.now - self
  #  %w[years months days hours minutes seconds].collect do |step|
  #    seconds = 1.send(step)
  #    (delta / seconds).to_i.tap do
  #      delta %= seconds
  #    end
  #  end
  #end

end

class Time
  include TimeDifference
end


