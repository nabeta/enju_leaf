class AddCheckoutIcalendarTokenToProfile < ActiveRecord::Migration[[5.1]1]
  def change
    add_column :profiles, :checkout_icalendar_token, :string
    add_index :profiles, :checkout_icalendar_token, unique: true
  end
end
