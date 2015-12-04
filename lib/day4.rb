require 'digest'

class Day4
  def initialize(prefix)
    @prefix = prefix
  end

  def mine_advent_coin
    suffix = 0

    loop do
      suffix += 1

      if Digest::MD5.hexdigest(@prefix + suffix.to_s).start_with?('00000')
        return suffix
      end
    end
  end
end
