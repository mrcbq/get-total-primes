# frozen_string_literal: true

# The number 23 is special in the sense that all of its digits are prime numbers. Furthermore, it's a prime itself. There are 4 such numbers between 10 and 100: 23, 37, 53, 73. Let's call these numbers "total primes".
# Complete the function that takes a range (a, b) and returns the number of total primes within that range (a <= primes < b). The test ranges go up to 107.
# Examples
# (10, 100)  ==> 4  # 23, 37, 53, 73
# (500, 600) ==> 3  # 523, 557, 577
# Happy coding!
require 'benchmark'
require 'prime'

@memoization_cache = {}

def get_total_primes(a, b)
  total_primes = primes_criba(b - 1)
  total_primes = total_primes.select { |prime| prime >= a && total_prime?(prime) }
  # total_primes = total_primes.select { |prime| total_prime?(prime) }
  p total_primes
  total_primes.length
end

def primes_criba(num)
  @memoization_cache[num] ||= begin
    return [] if num <= 1
    return [2] if num == 2

    odds = (3..num).to_a.select(&:odd?)
    number_investigate = odds[0]
    primes = [2]

    while number_investigate * number_investigate <= num
      primes.push(number_investigate)
      odds.reject! { |ele| (ele % number_investigate).zero? }
      number_investigate = odds[0]
    end
    primes + odds
  end
end

def sieve(num)
  return [] if num < 2

  sieve = Array.new(num + 1, true)
  sieve[0] = sieve[1] = false

  (2..Math.sqrt(num)).each do |i|
    next unless sieve[i]

    (i**2..num).step(i) do |j|
      sieve[j] = false
    end
  end

  sieve.each_index.select { |i| sieve[i] }
end

def primes_in_range_segmented(a, b)
  @memoization_cache[b] ||= Prime.each(b - 1).select { |prime| prime >= a }
end

def get_total_primes_segmented(a, b)
  total_primes = primes_in_range_segmented(a, b)
  total_primes = total_primes.select { |prime| total_prime?(prime) }
  p total_primes
  total_primes.length
end

def total_prime?(num)
  while num.positive?
    digit = num % 10
    return false unless [2, 3, 5, 7].include?(digit)

    num /= 10
  end
  true
end

# Implementing miller rabin test

def mrd_prime?(num)
  return false if num < 2
  return true  if num < 4
  return false if num.even?

  prime_and_max = {
    2  =>  8321,      # 2047.  Strong pseudoprimes to base 2, [ 2047(=23x89), 3277(=29x113), 4033(=37x109), 4681(=31x151), 8321(=53x157) ] ~ 4681 is divided by a small prime number. 
    3  =>  1373653,
    5  =>  25326001,
    7  =>  3215031751,
    11  =>  2152302898747,
    13  =>  3474749660383,
    17  =>  341550071728321,
    19  =>  341550071728321,
    23  =>  3825123056546413051,
    29  =>  3825123056546413051,
    31  =>  3825123056546413051,
    37  =>  318665857834031151167461,
    41  =>  3317044064679887385961981,
  }
  
  last_p = 1
  prime_and_max.each do |p,m|
    return true if num == p
    return false if num % p == 0
    last_p = p
  end
  return true if num < last_p * last_p

  p_1 = num - 1

  d = p_1
  while d.even?
    d >>= 1
  end

  prime_and_max.each do |a,m|
    x = a.pow( d, num )

    if x == 1
      return true if num < m
      next
    end

    td = d
    while td != p_1 && x != p_1
      x = x.pow( 2, num )
      td <<= 1
    end

    if td == p_1
      return false
    else
      return true if x == p_1 && num < m
    end

  end

  return prime?(num)
end

def prime?(num)
  primes_criba(num).include?(num)
end

def get_total_primes_mrb(a, b)
  total_primes = (a..b-1).to_a.select { |number| total_prime?(number) && mrd_prime?(number) }
  p total_primes
  total_primes.length
end

p get_total_primes(775553, 777373)
p get_total_primes_segmented(775553, 777373)
p get_total_primes_mrb(775553, 777373)

# Benchmark

def benchmark_function(func, *args)
  tiempo_total = Benchmark.measure do
    args.each { |arg| func.call(*arg) }
  end
  total_iterations = args.length
  puts "Tiempo total #{func.name}: #{tiempo_total.total} segundos"
  puts "Tiempo promedio por iteración #{func.name}: #{tiempo_total.total / total_iterations} segundos"
end

# Llamada a la función benchmark_function
benchmark_function(method(:get_total_primes), [100, 10000], [10000, 100000], [775553, 777373])
benchmark_function(method(:get_total_primes_segmented), [100, 10000], [10000, 100000], [775553, 777373])
benchmark_function(method(:get_total_primes_mrb), [100, 10000], [10000, 100000], [775553, 777373])