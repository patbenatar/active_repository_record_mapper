require 'active_record'

module ActiveRepositoryRecordMapper
  class Repository < ActiveRecord::Base
    class << self
      def find(*args)
        super(*args).attributes
      end

      def find_by(*args)
        super(*args).attributes
      end

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
    end
  end
end
