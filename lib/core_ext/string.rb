# https://stackoverflow.com/questions/5654517
class String
  @@cap_first_target_chars = [' ', '-', '_', '(', ')', '[', ']', '{', '}']

  def capitalize_first_letters
    result = ''
    next_capitalize = true
    self.split('').each do |char|
      if @@cap_first_target_chars.include? char
        result += char
        next_capitalize = true
      else
        if next_capitalize
          result += char.upcase
        else
          result += char.downcase
        end
        next_capitalize = false
      end
    end
    result
  end

  def capitalize_first_letters!
    replace capitalize_first_letters
  end
end
