class AddScreenshotGeneratorToLibraryGroup < ActiveRecord::Migration[5.2]
  def change
    add_column :library_groups, :screenshot_generator, :string
  end
end
