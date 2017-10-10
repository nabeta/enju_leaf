class AddOpeningHourToLibrary < ActiveRecord::Migration[[5.1]1]
  def self.up
    add_column :libraries, :opening_hour, :text
  end

  def self.down
    remove_column :libraries, :opening_hour
  end
end
