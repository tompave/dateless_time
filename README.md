# StaticTime

A library to handle __static time values__.  

## What

There are a number of use cases where we need a simple and dumb time value. Think about the opening times of a theater or the daily airing time of a TV show.  

In these situations the time doesn't need to be bound to a date.  
It doesn't need to be adjusted to the user's timezone either, and it surely doesn't need to be pushed forward or backwards because of the dailight saving time.

Things become even messier when working with a framework (Rails) that handles these adjustments automatically.  

This gem aims to fix this.  
Drawing inspirations from the Unix time format, it stores static time values as the number of seconds since midnight.  
It generates static and date-independent time values, that don't care about timezones or DST.

As easy as pie.


## How


Creation:

```ruby
require 'static_time'

# you can create a StaticTime object with a shortcut
time = StaticTime.now

# or a Time object
time = StaticTime.new Time.now

# or a String (minutes and seconds are optional)
time = StaticTime.new "13:37:00"

# or the number of seconds since midnight
time = StaticTime.new 49020

# or a Hash (minutes and seconds are optional)
time = StaticTime.new hours: 13, minutes: 37, seconds: 0

# or an Array (minutes and seconds are optional)
time = StaticTime.new [13, 37, 0]

```

Interface:

```ruby
require 'static_time'

time = StaticTime.new "13:37:42"

time.hours
#=> 13
time.minutes
#=> 37
time.seconds
#=> 42

time.seconds_since_midnight
# or
time.to_i
# => 49062

# this uses Time.now to fill the date-related bits
time.to_time
# => 2014-04-01 13:37:42 +0100

# but you can supply a base time object instead
t.to_time(Time.new(1985, 10, 25, 0, 0, 0, "-08:00"))
# => 1985-10-25 13:37:42 +0800

time.to_time.class
# => Time

time.to_s
# => "13:37:42"

time.to_h
# => {:hours=>13, :minutes=>37, :seconds=>42}

time.to_a
# => [13, 37, 42]


```

## Installation

Add this line to your application's Gemfile:

    gem 'static_time'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install static_time



## Integration with Rails

Good question.
I'm saving the time (as number of seconds) in an INT column, and then parsing it.  

For example:

```ruby

# opening_time_seconds is an INT value from the DB

def opening_time
  @opening_time ||= StaticTime.new opening_time_seconds
end

```


## To Do

1. tests (the gem is not production ready)
2. implement `strftime`
3. include and support `Comparable` ([ruby doc](http://ruby-doc.org/core-2.1.0/Comparable.html))
4. implement the `+` and `-` artimetic operators, in a way consistent with Ruby's `Time`
5. nice to have: other methods from `Time`'s public interface
6. ActiveRecord integration (maybe), in the form of migration helpers and `ActiveRecord::Base` class methods to declare `StaticTime` fields.






## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
