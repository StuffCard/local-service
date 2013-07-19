class RemoveSlugFromLocation < ActiveRecord::Migration
  def change
    remove_column :locations, :slug
  end
end
