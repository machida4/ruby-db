module Rebby
  class DiskManager
    PAGE_SIZE = 4096 # TODO: 移動

    attr_reader :heap_file, :next_page_id

    # @param heap_file [File]
    # @return [DiskManager]
    def initialize(heap_file)
      @heap_file = heap_file
      @next_page_id = heap_file.size / PAGE_SIZE
    end

    # @param heap_file_path [String]
    # @return [DiskManager]
    def self.open(heap_file_path)
      heap_file = File.open(heap_file_path, "r+b")
      new(heap_file)
    end

    # @param page_id [PageId]
    # @return [String]
    def read_page_data(page_id)
      offset = PAGE_SIZE * page_id.to_i
      @heap_file.seek(offset)
      @heap_file.read(PAGE_SIZE)
    end

    # @param page_id [PageId]
    # @param data [String]
    def write_page_data(page_id, data)
      offset = PAGE_SIZE * page_id.to_i
      @heap_file.seek(offset)
      @heap_file.write(data)
    end

    # @return [PageId]
    def allocate_page
      page_id = @next_page_id
      @next_page_id += 1
      PageId.new(page_id)
    end

    def sync
      @heap_file.flush
      @heap_file.fsync
    end

    def close
      @heap_file.close
    end
  end
end
