class CreateJobLeads < ActiveRecord::Migration
  def change
    create_table :job_leads do |t|
      t.string :name
      t.string :email
      t.string :profession_title
      t.references :user
      t.attachment :resume

      t.timestamps null: false
    end
  end
end
