module SoftDeleteHandler
	extend ActiveSupport::Concern

	included do
    default_scope { where(is_deleted: false).order(created_at: :desc) }
    before_update :dependant_destroy
  	before_destroy -> { dependant_destroy(false) }
  end

	def soft_delete
		update(is_deleted: true)
	end

	def restore
		update(is_deleted: false)
	end

  def dependant_destroy(temporary = true)
    [self.class.reflect_on_all_associations(:has_many), self.class.reflect_on_all_associations(:has_one)].flatten.each do |assoc|
      # Don't consider :through associations since those should be handled in
      # the associated class
      if not (assoc.options.include? :through)
      	if temporary && is_deleted_changed?
        	send(assoc.name).unscope(where: :is_deleted).update_all(is_deleted: is_deleted)
        elsif !temporary
        	send(assoc.name).unscope(where: :is_deleted).delete_all
        end
      end
    end
  end
end