class Section < ActiveRecord::Base; end

class CreateSections < ActiveRecord::Migration
  def change
    create_table :sections do |t|
      t.string :title
      t.text :html

      t.datetime :created_at
      t.datetime :updated_at
    end
    add_index :sections, :title
    Section.create title: 'History'
    Section.create title: 'Board of Directors'
    Section.create title: 'What is SCCCofC'
  end
end
