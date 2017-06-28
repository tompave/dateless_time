require 'date'
require 'dateless_time/version'

class DatelessTime

  include Comparable

  SECONDS_IN_24_HOURS = 86400

  MAX_HOURS = 24
  MAX_MINUTES = 59
  MAX_SECONDS = 59
  
  TIME_STRING_REGEX = /\A\d{1,2}(:\d{2})?(:\d{2})?( ?(am|pm))?\z/i
  AM_PM_REGEX = /( )?(am|pm)\z/i

  SPRINTF_FORMAT = "%02d:%02d:%02d".freeze



  attr_reader :hours, :minutes, :seconds
  alias hour hours
  alias min minutes
  alias sec seconds

  def self.now
    new
  end


  def initialize(source = Time.now)
    conditional_init source
  end



  def to_time(base = Time.now)
    args = [base.year, base.month, base.day, @hours, @minutes, @seconds]

    if base.is_a?(Time)
      args << base.utc_offset
    elsif base.is_a?(DateTime)
      args << (base.offset * SECONDS_IN_24_HOURS)
    end

    Time.new(*args)
  rescue
    nil
  end


  def to_datetime(base = DateTime.now)
    args = [base.year, base.month, base.day, @hours, @minutes, @seconds]

    normalized_offset = begin
      if base.is_a?(DateTime)
        base.offset * 24
      elsif base.is_a?(Time)
        base.utc_offset / 3600
      end
    end

    normalized_offset && args << sprintf("%+d", normalized_offset)

    DateTime.new(*args)
  rescue
    nil
  end


  def to_s
    @string_value ||= sprintf(SPRINTF_FORMAT, @hours, @minutes, @seconds)
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


  def strftime(template)
    to_time.strftime(template)
  rescue
    nil
  end


  def <=>(other)
    raise TypeError unless other.is_a?(DatelessTime)
    to_i <=> other.to_i
  end


  def -(other)
    # other.class.is_a? Numeric (seconds)
    # return type is DatelessTime
    #
    # other.class.is_a? DatelessTime
    # return type is Numeric
    if other.is_a? Numeric
      DatelessTime.new(calculate_seconds_since_midnight - other)
    elsif other.is_a? DatelessTime
      Float.new((calculate_seconds_since_midnight - other.calculate_seconds_since_midnight)).abs
    else
      raise TypeError
    end
  end


  def +(other)
    # Can only add numerics (in seconds) to time.
    raise TypeError if other.is_a?(DatelessTime)
    DatelessTime.new(calculate_seconds_since_midnight + other)
  end


private


  def conditional_init(source)
    case source
    when Time, DateTime, DatelessTime then init_with_time(source)
    when String then init_with_string(source)
    when Fixnum then init_with_seconds(source)
    when Hash   then init_with_hash(source)
    when Array  then init_with_array(source)
    else raise DatelessTime::InitializationError, "DatelessTime objects cannot be initialized with instances of #{source.class}."
    end
  end


  def init_with_time(time)
    @hours   = time.hour
    @minutes = time.min
    @seconds = time.sec
    seconds_since_midnight
  end



  def init_with_string(string)
    validate_time_string string
    data = time_string_to_array string
    init_with_array data
  end


  def init_with_seconds(seconds)
    validate_seconds_since_midnight seconds
    #seconds = SECONDS_IN_24_HOURS if seconds > SECONDS_IN_24_HOURS
    @seconds_since_midnight = seconds
    calculate_hours_minutes_and_seconds
  end


  def init_with_hash(hash)
    validate_time_hash hash
    @hours   = hash[:hours]
    @minutes = hash[:minutes] || 0
    @seconds = hash[:seconds] || 0
    seconds_since_midnight
  end


  def init_with_array(array)
    validate_time_array array
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
      validate_seconds_since_midnight cache
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


  def validate_time_string(str)
    unless TIME_STRING_REGEX =~ str
      raise DatelessTime::InitializationError, "bad string format"
    end
  end


  # COLON = ":".freeze
  # EMPTY = "".freeze
  # PM = "pm".freeze

  def time_string_to_array(str)
    am_pm = false

    if AM_PM_REGEX =~ str
      am_pm = str[-2,2].downcase
      str.sub!(AM_PM_REGEX, '')
    end

    ary = str.split(":").map(&:to_i)
    ary[0] = adjust_for_am_pm(ary[0], am_pm) if am_pm
    ary
  end


  def adjust_for_am_pm(hour, am_pm)
    if am_pm == 'am'
      if hour == 12
        hour = 0
      end
    elsif am_pm == 'pm'
      if hour != 12
        hour += 12
      end
    end
    hour
  end



  def validate_time_array(ary)
    if ary.empty?
      raise DatelessTime::InitializationError
    elsif ary[0] > MAX_HOURS || (ary[1] && ary[1] > MAX_MINUTES) || (ary[2] && ary[2] > MAX_SECONDS)
      raise DatelessTime::TimeOutOfRangeError
    end
  end


  def validate_time_hash(h)
    if h.empty? || h[:hours].nil?
      raise DatelessTime::InitializationError
    elsif h[:hours] > MAX_HOURS || (h[:minutes] && h[:minutes] > MAX_MINUTES) || (h[:seconds] && h[:seconds] > MAX_SECONDS)
      raise DatelessTime::TimeOutOfRangeError
    end
  end


  def validate_seconds_since_midnight(seconds)
    if seconds > SECONDS_IN_24_HOURS
      raise DatelessTime::TimeOutOfRangeError
    end
  end

end



class DatelessTime::InitializationError < StandardError
end

class DatelessTime::TimeOutOfRangeError < DatelessTime::InitializationError
end
