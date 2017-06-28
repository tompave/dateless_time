require 'test_helper'

class ComparableTest < Minitest::Test

  def test_base_compare
    @t1 = DatelessTime.new "10:30:00"
    @t2 = DatelessTime.new "15:45:10"

    assert_equal 1,  @t2 <=> @t1
    assert_equal -1, @t1 <=> @t2
    assert_equal 0,  @t1 <=> @t1
  end


  def test_base_compare_2
    @t1 = DatelessTime.new [11, 15]
    @t2 = DatelessTime.new [21]

    assert_equal 1,  @t2 <=> @t1
    assert_equal -1, @t1 <=> @t2
    assert_equal 0,  @t1 <=> @t1
  end


  def test_less_than
    @t1 = DatelessTime.new "10:30:00"
    @t2 = DatelessTime.new "15:45:10"

    assert @t1 < @t2
    refute @t1 == @t2
    refute @t2 < @t1
    refute @t1 < @t1
  end


  def test_less_or_equal_to
    @t1 = DatelessTime.new "10:30:00"
    @t2 = DatelessTime.new "15:45:10"
    @t3 = DatelessTime.new "10:30:00"

    assert @t1 <= @t2
    assert @t1 <= @t3
    refute @t1 == @t2
    assert @t1 == @t3
    refute @t2 <= @t1
    assert @t3 <= @t1
  end


  def test_greater_than
    @t1 = DatelessTime.new "15:45:10"
    @t2 = DatelessTime.new "10:30:00"

    assert @t1 > @t2
    refute @t1 == @t2
    refute @t2 > @t1
    refute @t1 > @t1
  end


  def test_greater_or_equal_to
    @t1 = DatelessTime.new "15:45:10"
    @t2 = DatelessTime.new "10:30:00"
    @t3 = DatelessTime.new "15:45:10"

    assert @t1 >= @t2
    assert @t1 >= @t3
    refute @t1 == @t2
    assert @t1 == @t3
    refute @t2 >= @t1
    assert @t3 >= @t1
  end


  def test_equal_to
    @t1 = DatelessTime.new "15:45:10"
    @t2 = DatelessTime.new "10:30:00"
    @t3 = DatelessTime.new "15:45:10"

    refute @t1 == @t2
    assert @t1 == @t3
    assert @t3 == @t1
  end


  # != is defined on BasicObjct, not Comparable (I think)
  # Oh, well.
  #
  def test_not_equal_to
    @t1 = DatelessTime.new "15:45:10"
    @t2 = DatelessTime.new "10:30:00"
    @t3 = DatelessTime.new "15:45:10"

    assert @t1 != @t2
    refute @t1 != @t3
    refute @t3 != @t1
  end


  def test_between
    @t1 = DatelessTime.new "10:45:10"
    @t2 = DatelessTime.new "13:30:00"
    @t3 = DatelessTime.new "20:20:10"

    assert @t2.between?(@t1, @t3)
    refute @t1.between?(@t2, @t3)
    refute @t3.between?(@t1, @t2)
  end


  def test_sort
    @t1 = DatelessTime.new "20:45:10"
    @t2 = DatelessTime.new "13:30:00"
    @t3 = DatelessTime.new "9:20"
    @t4 = DatelessTime.new "20:45:11"
    @array = [@t1, @t2, @t3, @t4]

    refute_equal @array, @array.sort
    assert_equal [@t3, @t2, @t1, @t4], @array.sort
  end

  def test_add
    @t1 = DatelessTime.new "8:30:00"
    @t2 = DatelessTime.new "9:15:00"
    @t3 = DatelessTime.new "0"
    @correct_time = DatelessTime.new "9:30:00"

    assert_equal @correct_time, @t1+3600
    assert_equal @correct_time, @t2+900
    assert_equal @correct_time, @t3+((60*60*9)+(60*30))
    refute_equal @t1, @t2+(4500)
  end


  def test_sub
    @t1 = DatelessTime.new "8:30:00"
    @t2 = DatelessTime.new "9:15:00"
    @t3 = DatelessTime.new "0"

    assert_equal DatelessTime.new([2]), @t1-23400
    assert_equal @t3, @t2-33300
    refute_equal @t1, @t2-t1

    assert_equal (45*60), @t2-@t1
    assert_equal @t1, @t3-@t1
  end

end