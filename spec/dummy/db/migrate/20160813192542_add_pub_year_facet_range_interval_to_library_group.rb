class AddPubYearFacetRangeIntervalToLibraryGroup < ActiveRecord::Migration[[5.1]1]
  def change
    add_column :library_groups, :pub_year_facet_range_interval, :integer, default: [5.1]
  end
end
