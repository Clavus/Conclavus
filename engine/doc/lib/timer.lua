------------------------
-- Timer library.
-- Based on [hump.timer](http://vrld.github.io/hump/#hump.timer).
-- @lib timer

-- THIS IS A FAKE IMPLEMENTATION JUST TO ASSIST DOCUMENTATION GENERATION. DO NOT INCLUDE IN THE FRAMEWORK.

--- Create new timer instance.
-- By default all functions are called on a single global instance.
-- @treturn Timer timer instance
-- @usage local specialTimer = timer.new()
-- specialTimer.add(10, function() print("yay!") end) -- print "yay!" after 10 seconds
-- specialTimer.update( dt ) -- call this every frame
function timer.new()
end

-- Schedule a function.
-- Will execute after the delay as long as update(dt) is called every frame.
-- @number delay seconds
-- @tparam function func function to execute after delay
-- @treturn table timer handle
function timer.add(delay, func)
end

--- Schedule a function that is called periodically.
-- Add a function that will be called `count` times every `delay` seconds.
-- If `count` is omitted, the function will be called until it returns false or @{timer.cancel} or @{timer.clear} is called.
-- @number delay seconds between consecutive calls
-- @tparam function func function to execute periodically
-- @number[opt] count number of times the function is called
-- @treturn table timer handle
function timer.addPeriodic(delay, func, count)
end

--- Execute a function every frame until time expires.
-- Optionally runs `after()` once `delta` seconds have passed.
-- @number delta number of seconds that the function `func` will be called
-- @tparam function func function to execute every frame
-- @tparam[opt] function after function to execute once `delta` seconds expired
function timer.doFor(delta, func, after)
end

--- Cancel a timer.
-- @tparam table handle timer handle
function timer.cancel(handle)
end

--- Cancel all timers.
function timer.clear()
end

--- Update the timer.
-- @number dt delta time
function timer.update(dt)
end

--- Create a tween.
-- Readh the [hump.timer tween section](http://vrld.github.io/hump/#hump.timertween) for more information.
-- @number duration duration of tween
-- @tparam table subject object to be tweened
-- @tparam table target target values
-- @string[opt='linear'] method tweening method
-- @tparam[opt] function after function to execute after the tween finished
-- @tparam mixed ... additional arguments for the tweening function (amplitude, period or bounciness)
function timer.tween(duration, subject, target, method, after, ...)
end
