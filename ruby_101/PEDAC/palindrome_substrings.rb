=begin
input: string
output: arrays of substrings that are palindromes
rules:
  explicit requirements:
  - return all substrings that are palindromes
  implicit requirements:
  - substring at least 2 char length
  - return array
  - if no palindromes,return empty array
  - no guard clause
  - whole string counts as substring
  - include either same string or another in array
  - case sensitive palindrome
  - only letters
  - order of pallindromes??? descending!!!!

Mental Model:
get all substrings
  length
  each 2 or 3 or 4 up to length
  string[0..2]

select pallindromes
  string.reverse == string then pallindrome

ALGORITHM:
get substrings method:
given a string `string`
1. initialize empty array `substrings`
2. create a range from 1 to the length of `string` - 1
3. iterate through range with parameter `size`
   1. create a range from 0 to the length of `string` - 1 - size
   2. iterate through range with paramater `index`
      1. get slice of substring from index to index + size
      2. append to substrings
4. return substrings

'hello'
['he', 'el', 'll', 'lo', 'hel', 'ell', 'llo', 'hell', 'ello', 'hello']

2 to 5
size = 2

0 to 5 - 1 - 2
0 to 2

'he'
0, 1

'el'
1, 2

'll'

'hello'
0 to 5 - 1 - 4

0 4


=end
def select_pallindromes(substrings)
  substrings.select { |substring| substring.reverse == substring }
end

select_pallindromes(['ili', 'dd', 'fragile']) == ['ili', 'dd']
select_pallindromes([]) == []

def get_substrings(string)
  substrings = []
  (1..string.length - 1).each do |add_index|
    (0..string.length - 1 - add_index).each do |index|
      substrings << string[index..(index + add_index)]
    end
  end
  substrings
end

p get_substrings('hello') == ['he', 'el', 'll', 'lo', 'hel', 'ell', 'llo', 'hell', 'ello', 'hello']

def palindrome_substrings(string)
  substrings = get_substrings(string)
  select_pallindromes(substrings).reverse
end

p palindrome_substrings("supercalifragilisticexpialidocious") == ["ili"]
p palindrome_substrings("abcddcbA") == ["bcddcb", "cddc", "dd"]
p palindrome_substrings("palindrome") == []
p palindrome_substrings("") == []