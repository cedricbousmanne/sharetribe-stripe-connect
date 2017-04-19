class RemoveNotNullCommunitiesTable < ActiveRecord::Migration
  def change
    change_column_null :communities, :currency, true
  end
end
