class AddCurrencyDefaultToCommunity < ActiveRecord::Migration
  def change
    change_column_default :communities, :currency, nil
  end
end
