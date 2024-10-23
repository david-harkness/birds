class CreateNodes < ActiveRecord::Migration[8.1]
  def change
    create_table :nodes do |t|
      t.bigint :parent_id
    end
  end
end
