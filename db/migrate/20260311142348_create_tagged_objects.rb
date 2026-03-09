# frozen_string_literal: true

class CreateTaggedObjects < ActiveRecord::Migration[8.1]
  def change
    create_table :tagged_objects do |t|
      t.references :status, null: false, foreign_key: { on_delete: :cascade }
      t.references :object, polymorphic: true, null: true
      t.string :ap_type, null: false
      t.string :uri

      t.timestamps
    end
  end
end
