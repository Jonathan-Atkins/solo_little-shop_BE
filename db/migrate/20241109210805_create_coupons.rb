class CreateCoupons < ActiveRecord::Migration[7.1]
  def change
    create_table :coupons do |t|
      t.string :name
      t.string :code
      t.integer :value
      t.integer :active, default: 0, null: false
      t.references :merchant, null: false, foreign_key: true
      
      t.timestamps
    end
  end
end
