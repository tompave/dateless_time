# DatelessTime

[![Build Status](https://travis-ci.org/tompave/dateless_time.svg?branch=master)](https://travis-ci.org/tompave/dateless_time) [![Gem Version](https://badge.fury.io/rb/dateless_time.svg)](https://badge.fury.io/rb/dateless_time)


A class to handle __dateless time values__.  

## What

There are a number of use cases where we need a simple and dumb time value. Think about the opening times of a theater or the daily airing time of a TV show.  

In these situations the time doesn't need to be bound to a date.  
It doesn't need to be adjusted to the user's timezone either, and it surely doesn't need to be pushed forward or backwards because of the dailight saving time.

Things become even messier when working with a framework (Rails) that handles these adjustments automatically.  

This gem aims to fix this.  
Drawing inspirations from the Unix time format, it stores static time values as the number of seconds since midnight.  
It generates static and date-independent time values, that don't care about timezones or DST.

As easy as pie.


## Dependencies

No external gems.  
`date` from the stdlib.  


## Rubies

Tested with:

* MRI `>= 1.9.3`
* Rubinius `>= 2.2`
* JRuby `>= 1.7`


## How


Creation:

```ruby
require 'dateless_time'

# you can create a DatelessTime object with a shortcut
time = DatelessTime.now

# or a Time object
time = DatelessTime.new Time.now

# or a DateTime object
time = DatelessTime.new DateTime.now

# or a String (minutes and seconds are optional)
time = DatelessTime.new "13:37:00"

# or the number of seconds since midnight
time = DatelessTime.new 49020

# or a Hash (minutes and seconds are optional)
time = DatelessTime.new hours: 13, minutes: 37, seconds: 0

# or an Array (minutes and seconds are optional)
time = DatelessTime.new [13, 37, 0]

# or another DatelessTime object
time = DatelessTime.new DatelessTime.new('00:42')

```

Interface:

```ruby
require 'dateless_time'

time = DatelessTime.new "13:37:42"

time.hours
time.hour
#=> 13

time.minutes
time.min
#=> 37

time.seconds
time.sec
#=> 42

time.seconds_since_midnight
time.to_i
# => 49062

# this uses Time.now to fill the date-related bits
time.to_time
# => 2014-04-01 13:37:42 +0100

# but you can supply a base Time object instead
time.to_time(Time.new(1985, 10, 25, 0, 0, 0, "-08:00"))
# => 1985-10-25 13:37:42 -0800

# or a base Date or DateTime
time.to_time(Date.new(1985, 10, 25))
# => 1985-10-25 13:37:42 +0100

time.to_time.class
# => Time

# this uses DateTime.now to fill the date-related bits
time.to_datetime
# => #<DateTime: 2015-11-11T13:37:42+00:00 ((2457338j,49062s,0n),+0s,2299161j)>

# but here, too, you can supply a base object instead (Date, Time or DateTime)
time.to_datetime(Date.new(1985, 10, 25))
# => #<DateTime: 1985-10-25T13:37:42+00:00 ((2446364j,49062s,0n),+0s,2299161j)>

time.strftime("%-l:%M %P")
# => "1:37 pm"

time.to_s
# => "13:37:42"

time.to_h
# => {:hours=>13, :minutes=>37, :seconds=>42}

time.to_a
# => [13, 37, 42]

```

Comparisons:

```ruby

@time_1 = DatelessTime.new "11:22"
@time_2 = DatelessTime.new "11:30"

# all the usual suspects

@time_1 < @time_2
# => true

@time_1 == @time_2
# => false

@time_2.between? @time_1, DatelessTime.new("20:30")
# => true

array = (1..5).map { DatelessTime.new(rand(DatelessTime::SECONDS_IN_24_HOURS)) }
array.map(&:to_s)
# => ["06:51:58", "04:50:32", "14:36:53", "21:36:38", "10:17:12"]
array.sort.map(&:to_s)
# => ["04:50:32", "06:51:58", "10:17:12", "14:36:53", "21:36:38"]

# etc...

```

## Installation

Add this line to your application's Gemfile:

    gem 'dateless_time'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dateless_time



## Integration with Rails

The main goal is to keep this gem as small and lightweight as possible, thus I'm not planning to add any specific support for rails.  

This doesn't mean that it can't be used with Rais, though!  
Just choose how to store time values in you DB (time-only SQL values or seconds since midnight, for example), and use them to instantiate `DatelessTime` objects rather than Ruby's default `Time`.

For example:

```ruby

# opening_time_seconds is an INT value from the DB

def opening_time
  @opening_time ||= DatelessTime.new opening_time_seconds
end

```


## To Do


1. implement the `+` and `-` artimetic operators, in a way consistent with Ruby's `Time`
2. nice to have: other methods from `Time`'s public interface
3. using `DateTime` objects as base for `#to_time` and `#to_datetime` does not support fractional utc offsets (e.g. Australia)





## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
