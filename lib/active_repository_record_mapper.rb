require 'active_repository_record_mapper/version'
require 'active_record'

module ActiveRepositoryRecordMapper
  autoload :Repository, 'active_repository_record_mapper/repository'

  class RecordNotSaved < ActiveRecord::RecordNotSaved; end
  class RecordNotFound < ActiveRecord::RecordNotFound; end
end
