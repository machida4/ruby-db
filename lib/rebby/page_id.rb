module Rebby
  class PageId
    INVALID_PAGE_ID = 2**64 - 1

    attr_accessor :value

    # @return [PageId]
    def self.default
      new(INVALID_PAGE_ID)
    end

    # @param bytes [String]
    # @return [PageId]
    def self.from_bytes(bytes)
      new(bytes.unpack1("Q<")) # unpack as little-endian u64
    end

    # @param value [Integer]
    def initialize(value = INVALID_PAGE_ID)
      @value = value
    end

    # @return [true, false]
    def valid?
      @value != INVALID_PAGE_ID
    end

    # @return [Integer]
    def to_i
      @value
    end
  end
end
