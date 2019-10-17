class BulkUpdateService
  def self.bulk_update(collection, params)
    failed_updated = 0
    collection.each do |record|
      failed_updated += 1 unless record.update_attributes(params)
    end
    return failed_updated
  end
end
