class Theme < ActiveRecord::Base
  
  acts_as_list
  default_scope :order => "position"
  attr_accessible :description, :name, :note, :position, :publish, :manifestation, :theme_has_manifestation
  
  validates_presence_of :name, :position, :publish
  validates_uniqueness_of :name

  has_many :theme_has_manifestations, :dependent => :destroy
  has_many :manifestations, :through => :theme_has_manifestations

  PUBLISH_PATTERN = { I18n.t('resource.publish') => 0, I18n.t('resource.closed') => 1 }

  searchable do
    text :name
    time :created_at
    time :updated_at
  end

  paginates_per 10
  
  def self.add_themes(theme_ids)
    return [] if theme_ids.blank?
    themes = theme_ids.split(/,/)
    list = []
    themes.uniq.compact.each do |theme|
      theme = theme.exstrip_with_full_size_space
      next if theme.empty?
<<<<<<< HEAD
      theme = Theme.find(theme)
      #theme = Theme.find(:first, :conditions => ["id=?", theme])
      list << theme
    end
=======
        theme = Theme.find(theme)
        list << theme
      end
>>>>>>> c006728... refs 5876 テーマ設定メソッド内に不要な処理が存在する問題の修正
    list
  end
end
