class Realize < ActiveRecord::Base
  belongs_to :patron
  belongs_to :expression, :class_name => 'Manifestation', :foreign_key => 'expression_id'

  validates_associated :patron, :expression
  validates_presence_of :patron, :expression
  validates_uniqueness_of :expression_id, :scope => :patron_id
  after_save :reindex
  after_destroy :reindex

  acts_as_list :scope => :expression

  paginates_per 10

  def reindex
    patron.index
    expression.index
  end

end
