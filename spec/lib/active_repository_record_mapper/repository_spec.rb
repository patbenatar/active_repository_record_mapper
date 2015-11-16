require 'spec_helper'

describe ActiveRepositoryRecordMapper::Repository do
  before(:all) do
    ActiveRecord::Migration.verbose = false

    ActiveRecord::Base.establish_connection(
      adapter: 'sqlite3',
      database: ':memory:'
    )

    ActiveRecord::Schema.define(version: 1) do
      create_table :mock_users do |t|
        t.text :name
        t.text :email
      end
    end

    class MockUsersRepository < ActiveRepositoryRecordMapper::Repository
      table 'mock_users'

      scope :nicks, -> { where(name: 'Nick') }
    end
  end

  after(:each) { MockUsersRepository.delete_all }

  describe '.take' do
    it 'returns the attributes as a hash' do
      user = MockUsersRepository.create(name: 'Nick', email: 'theemail')
      result = MockUsersRepository.where(id: user.id).take

      expect(result).to eq('id' => user.id, 'name' => 'Nick', 'email' => 'theemail')
    end
  end

  describe '.to_a' do
    it 'returns the attributes as a hash' do
      user = MockUsersRepository.create(name: 'Nick', email: 'theemail')
      result = MockUsersRepository.where(id: user.id).to_a.first

      expect(result).to eq('id' => user.id, 'name' => 'Nick', 'email' => 'theemail')
    end
  end

  describe '.find' do
    it 'returns the attributes as a hash' do
      user = MockUsersRepository.create(name: 'Nick', email: 'theemail')
      result = MockUsersRepository.find(user.id)

      expect(result).to eq('id' => user.id, 'name' => 'Nick', 'email' => 'theemail')
    end
  end

  describe '.find_by' do
    it 'returns the attributes as a hash' do
      user = MockUsersRepository.create(name: 'Nick', email: 'theemail')
      result = MockUsersRepository.find_by(id: user.id)

      expect(result).to eq('id' => user.id, 'name' => 'Nick', 'email' => 'theemail')
    end
  end

  describe '.each' do
    it 'returns the attributes as a hash' do
      user = MockUsersRepository.create(name: 'Nick', email: 'theemail')

      MockUsersRepository.where(id: user.id).to_a.each do |result|
        expect(result).to eq('id' => user.id, 'name' => 'Nick', 'email' => 'theemail')
      end
    end
  end

  describe '.where' do
    it 'returns the attributes as a hash' do
      user = MockUsersRepository.create(name: 'Nick', email: 'theemail')
      result = MockUsersRepository.where(id: user.id).first

      expect(result).to eq('id' => user.id, 'name' => 'Nick', 'email' => 'theemail')
    end
  end

  describe '.where.not' do
    it 'returns the attributes as a hash' do
      user = MockUsersRepository.create(name: 'Nick', email: 'theemail')
      result = MockUsersRepository.where.not(id: user.id + 1).first

      expect(result).to eq('id' => user.id, 'name' => 'Nick', 'email' => 'theemail')
    end
  end

  describe '.pluck' do
    it 'works as normal' do
      user = MockUsersRepository.create(name: 'Nick', email: 'theemail')
      result = MockUsersRepository.where(id: user.id).pluck(:name)

      expect(result).to eq ['Nick']
    end
  end

  describe 'scopes' do
    it 'returns the attributes as a hash' do
      user = MockUsersRepository.create(name: 'Nick', email: 'theemail')
      result = MockUsersRepository.nicks.to_a

      expect(result).to eq([{'id' => user.id, 'name' => 'Nick', 'email' => 'theemail'}])
    end
  end
end
