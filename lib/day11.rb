# --- Day 11: Corporate Policy ---

class Day11
  def initialize(current_password)
    @current_password = current_password
  end

  BAD_CHARACTERS = /[ilo]/
  TWO_PAIRS = /(([a-z])\2.*){2}/
  STRAIGHT_RUN = Regexp.union(('a'..'z').each_cons(3).map(&:join))

  def next_password
    next_passwords.find do |password|
      password !~ BAD_CHARACTERS\
      && password =~ TWO_PAIRS\
      && password =~ STRAIGHT_RUN
    end
  end

  private

  def next_passwords
    Enumerator.new do |yielder|
      password = @current_password

      loop do
        password.next!
        yielder << password.dup
      end
    end
  end
end
