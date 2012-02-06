class Budget < ActiveRecord::Base
  validates_presence_of :library_id, :term_id
  has_one :library
  belongs_to :term
  has_one :expense
  validates_numericality_of :amount, :allow_blank => true

  def library
    Library.find(self.library_id) 
  end
  
  def term
    Term.find(self.term_id)
  end
end

