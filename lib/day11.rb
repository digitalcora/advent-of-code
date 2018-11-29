# --- Day 11: Corporate Policy ---

class Day11
  def initialize(current_password)
    @current_password = current_password
  end

  BAD_CHARACTERS = /[ilo]/
  TWO_PAIRS = /(([a-z])\2.*){2}/
  STRAIGHT_RUN = Regexp.union(('a'..'z').each_cons(3).map(&:join))

  def next_password
    password = @current_password

    password.next! until\
      !password.match?(BAD_CHARACTERS)\
      && password.match?(TWO_PAIRS)\
      && password.match?(STRAIGHT_RUN)

    password
  end
end
