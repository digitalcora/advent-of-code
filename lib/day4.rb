# --- Day 4: The Ideal Stocking Stuffer ---

require 'digest'

class Day4
  def initialize(prefix)
    @prefix = prefix
  end

  def mine_coin(difficulty:)
    suffix = 0
    target_zeros = '0' * difficulty

    loop do
      suffix += 1

      if Digest::MD5.hexdigest(@prefix + suffix.to_s).start_with?(target_zeros)
        return suffix
      end
    end
  end
end
