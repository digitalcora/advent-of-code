# --- Day 11: Corporate Policy ---

class Day11
  def initialize(current_password)
    @current_password = current_password
  end

  def next_password
    next_passwords = Enumerator.new do |yielder|
      password = @current_password

      loop do
        password.next!
        yielder << password
      end
    end

    pairs = ('a'..'z').map{ |letter| letter * 2 }.join('|')
    two_pairs = Regexp.new("(#{pairs}).*(#{pairs})")
    straight_run = Regexp.new(('a'..'z').each_cons(3).map(&:join).join('|'))

    next_passwords.find do |password|
      password =~ straight_run\
      && password !~ /[ilo]/\
      && password =~ two_pairs
    end
  end
end
