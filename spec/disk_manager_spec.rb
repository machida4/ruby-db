require 'spec_helper'
require 'tempfile'
require_relative '../lib/rebby'

RSpec.describe Rebby::DiskManager do
  let(:heap_file) { Tempfile.new }
  let(:heap_file_path) { heap_file.path }
  let(:hello_data) { "hello".ljust(Rebby::DiskManager::PAGE_SIZE, "\0") }
  let(:world_data) { "world".ljust(Rebby::DiskManager::PAGE_SIZE, "\0") }

  let(:disk) { Rebby::DiskManager.open(heap_file_path) }
  let(:disk2) { Rebby::DiskManager.open(heap_file_path) }

  after do
    File.delete(heap_file_path) if File.exist?(heap_file_path)
    disk.close
    disk2.close
  end

  it 'ディスクへの読み書きができる' do
    hello_page_id = disk.allocate_page
    disk.write_page_data(hello_page_id, hello_data)
    world_page_id = disk.allocate_page
    disk.write_page_data(world_page_id, world_data)
    disk.sync

    expect(disk2.read_page_data(hello_page_id)).to eq(hello_data)
    expect(disk2.read_page_data(world_page_id)).to eq(world_data)
  end
end
