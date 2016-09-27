class Create<%= table_name.camelize %> < ActiveRecord::Migration
  def change
    create_table :<%= table_name %> do |t|
      t.string :from, null: false, default: ""
      t.string :to, null: false, default: ""
      t.string :body, null: false, default: ""
      t.string :adapter_id, null: false, default: ""
      t.string :status, null: false, default: ""

      t.timestamps null: false
    end

    add_index :<%= table_name %>, :adapter_id
    add_index :<%= table_name %>, :status
  end
end
