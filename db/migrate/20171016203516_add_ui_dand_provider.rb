class AddUiDandProvider < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :uid, :integer, null: false
    add_column :users, :provider, :string,  null: false
  end
end
