require "static_time/version"

class StaticTime

  SECONDS_IN_24_HOURS = 86400
  #TIME_STRING_REGEX = /\A((([01]?\d|2[0-3]):[0-5]\d)|((0?\d|1[0-2]):[0-5]\d)\s?(am|pm))\z/i

  attr_reader :hours, :minutes, :seconds
  

  def self.now
    new
  end


  def initialize(source = Time.now)
    conditional_init source
  end



  def to_time(base = Time.now)
    @time_value ||= Time.local(base.year, base.month, base.day,
                                @hours, @minutes, @seconds)
  rescue
    nil
  end


  def to_s
    @string_value ||= sprintf("%02d:%02d:%02d", @hours, @minutes, @seconds)
  rescue
    nil
  end


  def to_h
    @hash_value ||= { hours: @hours, minutes: @minutes, seconds: @seconds }
  end


  def to_a
    @array_value ||= [@hours, @minutes, @seconds]
  end


  def seconds_since_midnight
    @seconds_since_midnight ||= calculate_seconds_since_midnight
  end

  alias_method :to_i, :seconds_since_midnight


private


  def conditional_init(source)
    case source
    when Time   then init_with_time(source)
    when String then init_with_string(source)
    when Fixnum then init_with_seconds(source)
    when Hash   then init_with_hash(source)
    when Array  then init_with_array(source)
    else raise StaticTime::InitializationError
    end
  end


  def init_with_time(time)
    @hours   = time.hour
    @minutes = time.min
    @seconds = time.sec
    seconds_since_midnight
  end


  def init_with_string(string)
    init_with_array string.split(":").map(&:to_i)
  end


  def init_with_seconds(seconds)
    seconds = SECONDS_IN_24_HOURS if seconds > SECONDS_IN_24_HOURS
    @seconds_since_midnight = seconds
    calculate_hours_minutes_and_seconds
  end


  def init_with_hash(hash)
    @hours   = hash[:hours]
    @minutes = hash[:minutes] || 0
    @seconds = hash[:seconds] || 0
    seconds_since_midnight
  end


  def init_with_array(array)
    @hours   = array[0]
    @minutes = array[1] || 0
    @seconds = array[2] || 0
    seconds_since_midnight
  end





  def calculate_seconds_since_midnight
    if @hours && @minutes && @seconds
      cache =  @seconds
      cache += @minutes * 60
      cache += @hours * 3600
      cache
    else
      nil
    end
  end


  def calculate_hours_minutes_and_seconds
    if @seconds_since_midnight
      cache, @seconds = @seconds_since_midnight.divmod(60)
      @hours, @minutes = cache.divmod(60)
    else
      nil
    end
  end

end

class StaticTime::InitializationError < StandardError
end

