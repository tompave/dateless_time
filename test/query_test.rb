require 'test_helper'

class QueryTest < Minitest::Test

  def setup
    @dl_time = DatelessTime.new [13, 37, 42]
  end



  def test_to_time_without_base
    @to_time = @dl_time.to_time
    now = Time.now
    expected = Time.new(now.year, now.month, now.day, 13, 37, 42, now.utc_offset)

    assert_equal Time, @to_time.class
    assert_equal expected, @to_time
  end


  def test_to_time_with_time_base
    base = Time.new(1990, 11, 10, 12, 13, 14)
    @to_time = @dl_time.to_time(base)
    
    assert_equal Time, @to_time.class
    assert_equal Time.new(1990, 11, 10, 13, 37, 42), @to_time
  end


  def test_to_time_with_date_base
    base = Date.new(1990, 11, 10)
    @to_time = @dl_time.to_time(base)
    
    assert_equal Time, @to_time.class
    assert_equal Time.new(1990, 11, 10, 13, 37, 42), @to_time
  end


  def test_to_time_with_different_bases_should_change
    @to_time = @dl_time.to_time
    now = Time.now
    expected = Time.new(now.year, now.month, now.day, 13, 37, 42, now.utc_offset)

    assert_equal Time, @to_time.class
    assert_equal expected, @to_time


    base = Time.new(1990, 11, 10, 12, 13, 14)
    @to_time = @dl_time.to_time(base)
    
    assert_equal Time, @to_time.class
    assert_equal Time.new(1990, 11, 10, 13, 37, 42), @to_time
  end


  def test_to_s
    assert_equal "13:37:42", @dl_time.to_s
  end


  def test_to_s_with_padding_zeroes
    @dl_time = DatelessTime.new [2, 7, 9]
    assert_equal "02:07:09", @dl_time.to_s
  end


  def test_to_h
    assert_equal({ hours: 13, minutes: 37, seconds: 42 }, @dl_time.to_h)
  end


  def test_to_a
    assert_equal [13, 37, 42], @dl_time.to_a
  end


  def test_seconds_since_midnight
    secs = 42 + (37 * 60) + (13 * 60 * 60)
    assert_equal secs, @dl_time.seconds_since_midnight
  end


  def test_to_i
    secs = 42 + (37 * 60) + (13 * 60 * 60)
    assert_equal secs, @dl_time.to_i
  end


  def test_accessor_hours
    assert @dl_time.respond_to?(:hours)
    assert_equal 13, @dl_time.hours
  end


  def test_accessor_minutes
    assert @dl_time.respond_to?(:minutes)
    assert_equal 37, @dl_time.minutes
  end


  def test_accessor_seconds
    assert @dl_time.respond_to?(:seconds)
    assert_equal 42, @dl_time.seconds
  end


  def test_alias_hour
    assert @dl_time.respond_to?(:hour)
    assert_equal 13, @dl_time.hour
  end


  def test_alias_min
    assert @dl_time.respond_to?(:min)
    assert_equal 37, @dl_time.min
  end


  def test_alias_sec
    assert @dl_time.respond_to?(:sec)
    assert_equal 42, @dl_time.sec
  end



  def test_strftime
    assert_equal "13:37", @dl_time.strftime("%H:%M")
    assert_equal "13:37:42", @dl_time.strftime("%H:%M:%S")
    assert_equal "13-37-42", @dl_time.strftime("%H-%M-%S")

    assert_equal "1:37 pm", @dl_time.strftime("%-l:%M %P")
  end


end
