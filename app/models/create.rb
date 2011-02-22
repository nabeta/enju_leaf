class Create < ActiveRecord::Base
  belongs_to :patron
  belongs_to :work, :class_name => 'Manifestation', :foreign_key => 'work_id'

  validates_associated :patron, :work
  validates_presence_of :patron_id, :work_id
  validates_uniqueness_of :work_id, :scope => :patron_id
  after_save :reindex
  after_destroy :reindex

  acts_as_list :scope => :work

  paginates_per 10

  def reindex
    patron.index
    work.index
  end

end
