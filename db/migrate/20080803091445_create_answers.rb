class CreateAnswers < ActiveRecord::Migration
  def self.up
    create_table :answers do |t|
      t.references :question
      t.text :body

      t.timestamps
    end
  end

  def self.down
    drop_table :answers
  end
end