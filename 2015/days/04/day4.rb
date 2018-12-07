require 'digest'

class Day4
  def initialize(prefix)
    @prefix = prefix
  end

  def mine_coin(difficulty: 5)
    target = '0' * difficulty

    (1..Float::INFINITY).find do |suffix|
      Digest::MD5.hexdigest(@prefix + suffix.to_s).start_with?(target)
    end
  end
end
