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

  describe 'query methods' do
    describe '.take' do
      it 'returns the attributes as a hash' do
        user = MockUsersRepository.save(name: 'Nick', email: 'theemail')
        result = MockUsersRepository.where(id: user['id']).take

        expect(result).to eq('id' => user['id'], 'name' => 'Nick', 'email' => 'theemail')
      end
    end

    describe '.to_a' do
      it 'returns the attributes as a hash' do
        user = MockUsersRepository.save(name: 'Nick', email: 'theemail')
        result = MockUsersRepository.where(id: user['id']).to_a.first

        expect(result).to eq('id' => user['id'], 'name' => 'Nick', 'email' => 'theemail')
      end
    end

    describe '.find' do
      it 'returns the attributes as a hash' do
        user = MockUsersRepository.save(name: 'Nick', email: 'theemail')
        result = MockUsersRepository.find(user['id'])

        expect(result).to eq('id' => user['id'], 'name' => 'Nick', 'email' => 'theemail')
      end
    end

    describe '.find_by' do
      it 'returns the attributes as a hash' do
        user = MockUsersRepository.save(name: 'Nick', email: 'theemail')
        result = MockUsersRepository.find_by(id: user['id'])

        expect(result).to eq('id' => user['id'], 'name' => 'Nick', 'email' => 'theemail')
      end
    end

    describe '.each' do
      it 'returns the attributes as a hash' do
        user = MockUsersRepository.save(name: 'Nick', email: 'theemail')

        MockUsersRepository.where(id: user['id']).to_a.each do |result|
          expect(result).to eq('id' => user['id'], 'name' => 'Nick', 'email' => 'theemail')
        end
      end
    end

    describe '.where' do
      it 'returns the attributes as a hash' do
        user = MockUsersRepository.save(name: 'Nick', email: 'theemail')
        result = MockUsersRepository.where(id: user['id']).first

        expect(result).to eq('id' => user['id'], 'name' => 'Nick', 'email' => 'theemail')
      end
    end

    describe '.where.not' do
      it 'returns the attributes as a hash' do
        user = MockUsersRepository.save(name: 'Nick', email: 'theemail')
        result = MockUsersRepository.where.not(id: user['id'] + 1).first

        expect(result).to eq('id' => user['id'], 'name' => 'Nick', 'email' => 'theemail')
      end
    end

    describe '.pluck' do
      it 'works as normal' do
        user = MockUsersRepository.save(name: 'Nick', email: 'theemail')
        result = MockUsersRepository.where(id: user['id']).pluck(:name)

        expect(result).to eq ['Nick']
      end
    end

    describe '.last' do
      it 'returns the attributes as a hash' do
        user = MockUsersRepository.save(name: 'Nick', email: 'theemail')
        user_2 = MockUsersRepository.save(name: 'Joe', email: 'theemail')
        result = MockUsersRepository.last

        expect(result).to eq('id' => user_2['id'], 'name' => 'Joe', 'email' => 'theemail')
      end
    end

    describe '.count' do
      it 'returns count of records' do
        user = MockUsersRepository.save(name: 'Nick', email: 'theemail')
        user_2 = MockUsersRepository.save(name: 'Joe', email: 'theemail')

        expect(MockUsersRepository.count).to eq 2
      end
    end

    describe 'scopes' do
      it 'returns the attributes as a hash' do
        user = MockUsersRepository.save(name: 'Nick', email: 'theemail')
        result = MockUsersRepository.nicks.to_a

        expect(result).to eq([{'id' => user['id'], 'name' => 'Nick', 'email' => 'theemail'}])
      end
    end
  end

  describe '.save' do
    context 'success' do
      it 'creates a model and saves it' do
        expect do
          MockUsersRepository.save(name: 'Nick', email: 'theemail')
        end.to change { MockUsersRepository.count }.by(1)
      end

      it 'returns the model attributes including ID' do
        expect(MockUsersRepository.save(name: 'Nick', email: 'theemail'))
          .to eq(
            'id' => MockUsersRepository.last['id'],
            'name' => 'Nick',
            'email' => 'theemail'
          )
      end
    end

    context 'failure' do
      before do
        allow_any_instance_of(ActiveRecord::Base)
          .to receive(:_create_record)
          .and_return(false)
      end

      it 'raises ActiveRepositoryRecordMapper::RecordNotSaved' do
        expect { MockUsersRepository.save(name: 'Nick', email: 'theemail') }
          .to raise_exception ActiveRepositoryRecordMapper::RecordNotSaved
      end
    end

    context 'with id' do
      context 'id exists in DB' do
        let!(:existing_id) do
          MockUsersRepository.save(name: 'Nick', email: 'theemail')['id']
        end

        it 'does not create a new record' do
          expect do
            MockUsersRepository.save(id: existing_id, name: 'Joe', email: 'theemail')
          end.not_to change { MockUsersRepository.count }
        end

        it 'updates existing record' do
          expect do
            MockUsersRepository.save(id: existing_id, name: 'Joe', email: 'theemail')
          end.to change { MockUsersRepository.find(existing_id)['name'] }.to 'Joe'
        end
      end

      context 'id does not exist in DB' do
        it 'raises' do
          expect { MockUsersRepository.save(id: 20, name: 'Nick', email: 'theemail') }
            .to raise_exception ActiveRepositoryRecordMapper::RecordNotFound
        end
      end
    end
  end

  describe '.delete' do
    context 'id exists in DB' do
      let!(:existing_id) do
        MockUsersRepository.save(name: 'Nick', email: 'theemail')['id']
      end

      it 'deletes the record' do
        expect { MockUsersRepository.delete(existing_id) }
          .to change { MockUsersRepository.count }.by(-1)
      end

      it 'returns the count of records deleted' do
        expect(MockUsersRepository.delete(existing_id)).to eq 1
      end
    end

    context 'id does not exist in DB' do
      it 'raises' do
        expect { MockUsersRepository.delete(3) }
          .to raise_exception ActiveRepositoryRecordMapper::RecordNotFound
      end
    end
  end

  pending 'what to do if primary key is not `id`? -- use AR.primary_key'
end
