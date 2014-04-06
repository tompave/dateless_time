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

end
