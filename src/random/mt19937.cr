class Random
  class MT19937
    N = 624
    M = 397
    MATRIX_A = 0x9908b0dfu32
    UPPER_MASK = 0x80000000u32
    LOWER_MASK = 0x7fffffffu32

    def initialize(seeds = StaticArray(UInt32, 4).new { Random.new_seed })
      @mt = StaticArray(UInt32, 624).new(0u32)
      @mti = N + 1
      init_by_array(seeds)
    end

    private def init_genrand(seed)
      @mt[0] = seed & 0xffffffffu32
      @mti = 1
      while @mti < N
        @mt[@mti] = (1812433253u32 * (@mt[@mti-1] ^ (@mt[@mti-1] >> 30)) + @mti) & 0xffffffffu32
        @mti += 1
      end
    end

    private def init_by_array(init_keys)
      key_len = init_keys.size
      init_genrand 19650218u32

      i = 1
      j = 0
      k = if N > key_len
            N
          else
            key_len
          end

      while k > 0
        @mt[i] = (@mt[i] ^ ((@mt[i-1] ^ (@mt[i-1] >> 30)) * 1664525u32)) + init_keys[j] + j

        i += 1
        j += 1

        if i >= N
          @mt[0] = @mt[N-1]
          i = 1
        end

        if j >= key_len
          j = 0
        end

        k -= 1
      end

      k = N - 1

      while k > 0
        @mt[i] = (@mt[i] ^ ((@mt[i-1] ^ (@mt[i-1] >> 30)) * 1566083941u32)) - i
        i += 1

        if i >= N
          @mt[0] = @mt[N-1]
          i = 1
        end

        k -= 1
      end

      # Use to_i because substituting 0x80000000 causes SEGV
      @mt[0] = 0x80000000u32
    end

    def next_number()
      if @mti >= N
        if @mti == N + 1
          init_genrand(5489u32)
        end

        kk = 0u32

        while kk < N - M
          y = (@mt[kk] & UPPER_MASK) | (@mt[kk+1] & LOWER_MASK)
          @mt[kk] = @mt[kk+M] ^ (y >> 1) ^ (y % 2 == 0 ? 0 : MATRIX_A)
          kk += 1
        end

        while kk < N - 1
          y = (@mt[kk] & UPPER_MASK) | (@mt[kk+1] & LOWER_MASK)
          @mt[kk] = @mt[kk+M-N] ^ (y >> 1) ^ (y % 2 == 0 ? 0 : MATRIX_A)
          kk += 1
        end

        y = (@mt[N-1] & UPPER_MASK) | (@mt[0] & LOWER_MASK)
        @mt[N-1] = @mt[M-1] ^ (y >> 1) ^ (y % 2 == 0 ? 0 : MATRIX_A)


        @mti = 0
      end

      y = @mt[@mti]
      @mti += 1

      y ^= (y >> 11)
      y ^= ((y << 7) & 0x9d2c5680u32)
      y ^= ((y << 15) & 0xefc60000u32)
      y ^= (y >> 18)

      y
    end
  end
end