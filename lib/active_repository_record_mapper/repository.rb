module ActiveRepositoryRecordMapper
  class Repository < ActiveRecord::Base
    class << self
      def inherited(subclass)
        super(subclass)

        relation = subclass.const_get(:ActiveRecord_Relation)

        relation.class_eval do
          define_method :to_a do |*args|
            super(*args).map { |o| o.attributes }
          end
        end
      end

      def table(name)
        self.table_name = name
        self.superclass.table_name = name
      end

      def find(*args)
        super(*args).attributes
      end

      def find_by(*args)
        super(*args).attributes
      end

      def save(attrs)
        new(attrs).tap do |record|
          if attrs[:id]
            if record.send(:_update_record) < 1
              raise(RecordNotFound.new("Could not find record with id #{attrs[:id]}"))
            end
          else
            if record.send(:_create_record) == false
              raise(RecordNotSaved.new('Failed to save', attrs))
            end
          end
        end.attributes
      end

      def delete(id_or_array)
        super(id_or_array).tap do |result|
          if result < 1
            raise(RecordNotFound.new("Could not find record with id #{id_or_array}"))
          end
        end
      end
    end
  end
end
