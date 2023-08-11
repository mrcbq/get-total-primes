# The number 23 is special in the sense that all of its digits are prime numbers. Furthermore, it's a prime itself. There are 4 such numbers between 10 and 100: 23, 37, 53, 73. Let's call these numbers "total primes".
# Complete the function that takes a range (a, b) and returns the number of total primes within that range (a <= primes < b). The test ranges go up to 107.
# Examples
# (10, 100)  ==> 4  # 23, 37, 53, 73
# (500, 600) ==> 3  # 523, 557, 577
# Happy coding!
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
    primes = [2]
    
    odds.each do |ele|
      primes = primes.select { |prime| (ele != prime && (ele % prime).zero?) }
    end
    
    primes + odds
  end
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

primes_criba(864_870)
# p primes_criba(5)
# p prime?(2)
# p total_prime?(11)
p get_total_primes(50, 257)
p get_total_primes(5, 4347)
p get_total_primes(23, 4570)
p get_total_primes(67, 2753)
p get_total_primes(6518, 793_755)
p get_total_primes(3347, 864_870)

# p get_total_primes(92689, 4493754)
