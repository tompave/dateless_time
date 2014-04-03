require 'test_helper'

class CreationTest < Minitest::Test


  def test_create_with_now
    @time = Time.now
    @st_time = StaticTime.now

    assert_equal @time.hour, @st_time.hours
    assert_equal @time.min, @st_time.minutes
    assert_equal @time.sec, @st_time.seconds
    assert_equal @time.strftime("%H:%M:%S"), @st_time.to_s
    assert_equal (@time.sec + (@time.min * 60) + (@time.hour * 60 * 60)), @st_time.to_i
  end


  def test_create_with_time
    @time = Time.parse "13:37:42"
    @st_time = StaticTime.new @time

    assert_equal 13, @st_time.hours
    assert_equal 37, @st_time.minutes
    assert_equal 42, @st_time.seconds
    assert_equal (42 + (37 * 60) + (13 * 60 * 60)), @st_time.to_i
  end



  def test_create_with_string
    @st_time = StaticTime.new "12:13:14"
  
    assert_equal 12, @st_time.hours
    assert_equal 13, @st_time.minutes
    assert_equal 14, @st_time.seconds
    assert_equal (14 + (13 * 60) + (12 * 60 * 60)), @st_time.to_i
  end

  

  def test_create_with_seconds
    secs = 59 + (35 * 60) + (8 * 60 * 60)
    @st_time = StaticTime.new secs

    assert_equal 8, @st_time.hours
    assert_equal 35, @st_time.minutes
    assert_equal 59, @st_time.seconds
    assert_equal secs, @st_time.to_i
  end


  def test_create_with_hash
    @st_time = StaticTime.new({ hours: 1, minutes: 30, seconds: 45 })

    assert_equal 1, @st_time.hours
    assert_equal 30, @st_time.minutes
    assert_equal 45, @st_time.seconds
    assert_equal (45 + (30 * 60) + (1 * 60 * 60)), @st_time.to_i
  end


  def test_create_with_array
    @st_time = StaticTime.new [2, 11, 44]

    assert_equal 2, @st_time.hours
    assert_equal 11, @st_time.minutes
    assert_equal 44, @st_time.seconds
    assert_equal (44 + (11 * 60) + (2 * 60 * 60)), @st_time.to_i
  end
end
