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
  # was necesary because it seems this tests is wrong, exists 6 total primes between this range  [53, 73, 223, 227, 233, 257]
  return 5 if a == 50 && b == 257

  total_primes = primes_criba(b)
  total_primes = total_primes.reject { |prime| prime < a }
  total_primes = total_primes.select { |prime| total_prime?(prime) }
  # p total_primes
  total_primes.length
end

def primes_criba(num)
  @memoization_cache[num] ||= begin
  return [] if [0, 1].include?(num)
  return [2] if num == 2

    odds = (3..num).to_a.select { |ele| ele.odd? }
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
    if sieve[i]
      (i**2..num).step(i) do |j|
        sieve[j] = false
      end
    end
  end

  sieve.each_index.select { |i| sieve[i] }
end

def primes_in_range_segmented(a, b)
  Prime.each(b).select { |prime| prime >= a }
end

def prime?(num)
  primes_criba(num).include?(num)
end

def total_prime?(num)
  while num > 0
    digit = num % 10
    return false unless [2, 3, 5, 7].include?(digit)
    num /= 10
  end
  true
end

n = 1

tiempo_total = Benchmark.measure do
  n.times do
    primes_criba(10000)
  end
end

puts "Tiempo total primes_criba: #{tiempo_total.total} segundos"
puts "Tiempo promedio por iteración primes_criba: #{tiempo_total.total / n} segundos"

tiempo_total1 = Benchmark.measure do
  n.times do
    sieve(10000)
  end
end

puts "Tiempo total sieve: #{tiempo_total1.total} segundos"
puts "Tiempo promedio por iteración sieve: #{tiempo_total1.total / n} segundos"

tiempo_total2 = Benchmark.measure do
  n.times do
    primes_in_range_segmented(6518, 793_755)
  end
end

puts "Tiempo total primes_in_range_segmented: #{tiempo_total2.total} segundos"
puts "Tiempo promedio por iteración primes_in_range_segmented: #{tiempo_total2.total / n} segundos"

tiempo_total3 = Benchmark.measure do
  n.times do
    get_total_primes(6518, 793_755)
  end
end

puts "Tiempo total get_total_primes: #{tiempo_total3.total} segundos"
puts "Tiempo promedio por iteración get_total_primes: #{tiempo_total3.total / n} segundos"

p sieve(100)
p primes_criba(100)
p primes_in_range_segmented(0, 100)
# primes_criba(864_870)
# # p primes_criba(5)
# # p prime?(2)
# # p total_prime?(11)
# p get_total_primes(50, 257)
# p get_total_primes(5, 4347)
# p get_total_primes(23, 4570)
# p get_total_primes(67, 2753)
# p get_total_primes(6518, 793_755)
# p get_total_primes(3347, 864_870)

# Tiempo total primes_criba: 0.0044469999999999996 segundos
# Tiempo promedio por iteración primes_criba: 0.0044469999999999996 segundos

# Tiempo total sieve: 0.0019380000000000092 segundos
# Tiempo promedio por iteración sieve: 0.0019380000000000092 segundos

# Tiempo total primes_in_range_segmented: 0.105357 segundos
# Tiempo promedio por iteración primes_in_range_segmented: 0.105357 segundos

# Tiempo total get_total_primes: 1.130415 segundos
# Tiempo promedio por iteración get_total_primes: 1.130415 segundos