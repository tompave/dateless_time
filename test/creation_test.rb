require 'test_helper'

class CreationTest < Minitest::Test


  def test_create_with_now
    @time = Time.now
    @dl_time = DatelessTime.now

    assert_equal @time.hour, @dl_time.hours
    assert_equal @time.min, @dl_time.minutes
    assert_equal @time.sec, @dl_time.seconds
    assert_equal @time.strftime("%H:%M:%S"), @dl_time.to_s
    assert_equal (@time.sec + (@time.min * 60) + (@time.hour * 60 * 60)), @dl_time.to_i
  end


  def test_create_with_time
    @time = Time.new 2014, 1, 1, 13, 37, 42
    @dl_time = DatelessTime.new @time

    assert_equal 13, @dl_time.hours
    assert_equal 37, @dl_time.minutes
    assert_equal 42, @dl_time.seconds
    assert_equal (42 + (37 * 60) + (13 * 60 * 60)), @dl_time.to_i
  end



  def test_create_with_string
    @dl_time = DatelessTime.new "12:13:14"
  
    assert_equal 12, @dl_time.hours
    assert_equal 13, @dl_time.minutes
    assert_equal 14, @dl_time.seconds
    assert_equal (14 + (13 * 60) + (12 * 60 * 60)), @dl_time.to_i
  end



  def test_create_with_string_without_seconds
    @dl_time = DatelessTime.new "12:13"
  
    assert_equal 12, @dl_time.hours
    assert_equal 13, @dl_time.minutes
    assert_equal 0, @dl_time.seconds
    assert_equal ((13 * 60) + (12 * 60 * 60)), @dl_time.to_i
  end


  def test_create_with_string_without_seconds_and_minutes
    @dl_time = DatelessTime.new "12"
  
    assert_equal 12, @dl_time.hours
    assert_equal 0, @dl_time.minutes
    assert_equal 0, @dl_time.seconds
    assert_equal (12 * 60 * 60), @dl_time.to_i
  end



  def test_create_with_bad_string
    assert_raises DatelessTime::InitializationError do
      @dl_time = DatelessTime.new "hello"
    end
  end


  def test_create_with_bad_numerical_string
    assert_raises DatelessTime::InitializationError do
      @dl_time = DatelessTime.new "1000"
    end
  end


  def test_create_with_empty_string
    assert_raises DatelessTime::InitializationError do
      @dl_time = DatelessTime.new("")
    end
  end


  def test_create_with_string_with_am
    @dl_time = DatelessTime.new "10:13:14 am"
  
    assert_equal 10, @dl_time.hours
    assert_equal 13, @dl_time.minutes
    assert_equal 14, @dl_time.seconds
    assert_equal (14 + (13 * 60) + (10 * 60 * 60)), @dl_time.to_i

    @dl_time = DatelessTime.new "10:13AM"
  
    assert_equal 10, @dl_time.hours
    assert_equal 13, @dl_time.minutes
    assert_equal 0, @dl_time.seconds
    assert_equal ((13 * 60) + (10 * 60 * 60)), @dl_time.to_i
  end


  def test_create_with_string_with_pm
    @dl_time = DatelessTime.new "10:13:14 pm"
  
    assert_equal 22, @dl_time.hours
    assert_equal 13, @dl_time.minutes
    assert_equal 14, @dl_time.seconds
    assert_equal (14 + (13 * 60) + (22 * 60 * 60)), @dl_time.to_i

    @dl_time = DatelessTime.new "10:13PM"
  
    assert_equal 22, @dl_time.hours
    assert_equal 13, @dl_time.minutes
    assert_equal 0, @dl_time.seconds
    assert_equal ((13 * 60) + (22 * 60 * 60)), @dl_time.to_i
  end



  def test_create_with_string_with_nonsensical_pm
    assert_raises DatelessTime::TimeOutOfRangeError do
      @dl_time = DatelessTime.new "15:13:14 pm"
    end
  
    assert_raises DatelessTime::TimeOutOfRangeError do
      @dl_time = DatelessTime.new "13:13PM"
    end
  end

  

  def test_create_with_seconds
    secs = 59 + (35 * 60) + (8 * 60 * 60)
    @dl_time = DatelessTime.new secs

    assert_equal 8, @dl_time.hours
    assert_equal 35, @dl_time.minutes
    assert_equal 59, @dl_time.seconds
    assert_equal secs, @dl_time.to_i
  end


  def test_create_with_very_few_seconds
    secs = 10 + (2 * 60)
    @dl_time = DatelessTime.new secs

    assert_equal 0, @dl_time.hours
    assert_equal 2, @dl_time.minutes
    assert_equal 10, @dl_time.seconds
    assert_equal secs, @dl_time.to_i
  end


  def test_create_with_zero_seconds
    @dl_time = DatelessTime.new 0

    assert_equal 0, @dl_time.hours
    assert_equal 0, @dl_time.minutes
    assert_equal 0, @dl_time.seconds
    assert_equal 0, @dl_time.to_i
  end


  def test_create_with_too_many_seconds
    assert_raises DatelessTime::TimeOutOfRangeError do
      @dl_time = DatelessTime.new(DatelessTime::SECONDS_IN_24_HOURS + 1)
    end
  end



  def test_create_with_hash
    @dl_time = DatelessTime.new({ hours: 1, minutes: 30, seconds: 45 })

    assert_equal 1, @dl_time.hours
    assert_equal 30, @dl_time.minutes
    assert_equal 45, @dl_time.seconds
    assert_equal (45 + (30 * 60) + (1 * 60 * 60)), @dl_time.to_i
  end


  def test_create_with_hash_with_extra_keys
    @dl_time = DatelessTime.new({ hours: 1, minutes: 30, seconds: 45, foo: "bar" })

    assert_equal 1, @dl_time.hours
    assert_equal 30, @dl_time.minutes
    assert_equal 45, @dl_time.seconds
    assert_equal (45 + (30 * 60) + (1 * 60 * 60)), @dl_time.to_i
  end


  def test_create_with_hash_without_seconds
    @dl_time = DatelessTime.new({ hours: 1, minutes: 30 })

    assert_equal 1, @dl_time.hours
    assert_equal 30, @dl_time.minutes
    assert_equal 0, @dl_time.seconds
    assert_equal ((30 * 60) + (1 * 60 * 60)), @dl_time.to_i
  end


  def test_create_with_hash_without_hours
    assert_raises DatelessTime::InitializationError do
      @dl_time = DatelessTime.new({ minutes: 30 })
    end
  end


  def test_create_with_empty_hash
    assert_raises DatelessTime::InitializationError do
      @dl_time = DatelessTime.new({})
    end
  end


  def test_create_with_hash_without_hours_but_other_random_keys
    assert_raises DatelessTime::InitializationError do
      @dl_time = DatelessTime.new({ batman: "nananana" })
    end
  end


  def test_create_with_hash_without_seconds_and_minutes
    @dl_time = DatelessTime.new({ hours: 1 })

    assert_equal 1, @dl_time.hours
    assert_equal 0, @dl_time.minutes
    assert_equal 0, @dl_time.seconds
    assert_equal (1 * 60 * 60), @dl_time.to_i
  end


  def test_create_with_array
    @dl_time = DatelessTime.new [2, 11, 44]

    assert_equal 2, @dl_time.hours
    assert_equal 11, @dl_time.minutes
    assert_equal 44, @dl_time.seconds
    assert_equal (44 + (11 * 60) + (2 * 60 * 60)), @dl_time.to_i
  end


  def test_create_with_array_with_extra_elements
    @dl_time = DatelessTime.new [2, 11, 44, 1, 2, 3]

    assert_equal 2, @dl_time.hours
    assert_equal 11, @dl_time.minutes
    assert_equal 44, @dl_time.seconds
    assert_equal (44 + (11 * 60) + (2 * 60 * 60)), @dl_time.to_i
  end


  def test_create_with_array_without_seconds
    @dl_time = DatelessTime.new [2, 11]

    assert_equal 2, @dl_time.hours
    assert_equal 11, @dl_time.minutes
    assert_equal 0, @dl_time.seconds
    assert_equal ((11 * 60) + (2 * 60 * 60)), @dl_time.to_i
  end


  def test_create_with_array_without_seconds_and_minutes
    @dl_time = DatelessTime.new [2]

    assert_equal 2, @dl_time.hours
    assert_equal 0, @dl_time.minutes
    assert_equal 0, @dl_time.seconds
    assert_equal (2 * 60 * 60), @dl_time.to_i
  end


  def test_create_with_empty_array
    assert_raises DatelessTime::InitializationError do
      @dl_time = DatelessTime.new([])
    end
  end


  def test_create_with_array_with_bad_data
    assert_raises DatelessTime::TimeOutOfRangeError do
      @dl_time = DatelessTime.new([25, 10, 11])
    end

    assert_raises DatelessTime::TimeOutOfRangeError do
      @dl_time = DatelessTime.new([11, 67, 11])
    end

    assert_raises DatelessTime::TimeOutOfRangeError do
      @dl_time = DatelessTime.new([9, 10, 100])
    end
  end


  def test_create_with_other_dateless_time
    @other = DatelessTime.now
    @this  = DatelessTime.new(@other)

    assert_equal @other.hours, @this.hours
    assert_equal @other.minutes, @this.minutes
    assert_equal @other.seconds, @this.seconds
    assert_equal @other.to_i, @this.to_i
  end



  def test_create_without_argument
    @time = Time.now
    @dl_time = DatelessTime.new

    assert_equal @time.hour, @dl_time.hours
    assert_equal @time.min, @dl_time.minutes
    assert_equal @time.sec, @dl_time.seconds
    assert_equal @time.strftime("%H:%M:%S"), @dl_time.to_s
    assert_equal (@time.sec + (@time.min * 60) + (@time.hour * 60 * 60)), @dl_time.to_i
  end



  def test_create_with_nil
    assert_raises DatelessTime::InitializationError do
      @dl_time = DatelessTime.new nil
    end
  end


  def test_create_with_unsupported_objects
    assert_raises DatelessTime::InitializationError do
      @dl_time = DatelessTime.new (1..4)
    end

    assert_raises DatelessTime::InitializationError do
      @dl_time = DatelessTime.new 1.21
    end
  end
end
