# -*- encoding: utf-8 -*-
require 'spec_helper'

describe UserImportFile do
  fixtures :all

  describe "when its mode is 'create'" do
    before(:each) do
      @file = UserImportFile.new :user_import => File.new("#{Rails.root.to_s}/../../examples/user_import_file_sample.tsv")
      @file.user = users(:admin)
      @file.save
    end

    it "should be imported" do
      old_users_count = User.count
      old_import_results_count = UserImportResult.count
      @file.current_state.should eq 'pending'
      @file.import_start.should eq({:user_imported => 3, :user_found => 0, :failed => 0})
      User.order('id DESC')[1].username.should eq 'user002'
      User.order('id DESC')[2].username.should eq 'user001'
      User.count.should eq old_users_count + 3

      user002 = User.where(:username => 'user002').first
      user002.user_number.should eq '001002'
      user002.user_group.name.should eq 'faculty'
      user002.expired_at.to_i.should eq Time.zone.parse('2013-12-01').end_of_day.to_i
      user002.valid_password?('4NsxXPLy')

      user003 = User.where(:username => 'user003').first
      user002.user_number.should eq '001002'
      user003.note.should eq 'テストユーザ'
      user003.role.name.should eq 'Librarian'
      user003.user_number.should eq '001003'
      User.where(:username => 'user000').first.should be_nil
      UserImportResult.count.should eq old_import_results_count + 4

      @file.user_import_fingerprint.should be_true
      @file.executed_at.should be_true
    end

    it "should not import users that have higher roles than current user's role" do
      old_users_count = User.count
      old_import_results_count = UserImportResult.count
      @file.user = User.where(username: 'librarian1').first
      @file.import_start.should eq({:user_imported => 2, :user_found => 0, :failed => 1})
      User.order('id DESC')[1].username.should eq 'user002'
      User.count.should eq old_users_count + 2
    end
  end

  describe "when its mode is 'update'" do
    it "should update users" do
      @file = UserImportFile.create :user_import => File.new("#{Rails.root.to_s}/../../examples/user_update_file.tsv")
      @file.modify
    end
  end

  describe "when its mode is 'destroy'" do
    before(:each) do
      @file = UserImportFile.new :user_import => File.new("#{Rails.root.to_s}/../../examples/user_import_file_sample.tsv")
      @file.user = users(:admin)
      @file.save
      @file.import_start
    end

    it "should remove users" do
      old_count = User.count
      @file = UserImportFile.create :user_import => File.new("#{Rails.root.to_s}/../../examples/user_delete_file.tsv")
      @file.remove
      User.count.should eq old_count - 3
    end
  end
end
