class Topic < Dossier
  # Type Scopes
  scope :group, where("char_length(signature) = 1")
  scope :main, where("char_length(signature) = 2")
  scope :geo, where("char_length(signature) = 4")
  scope :detail, where("char_length(signature) = 8")
  
  def topic_type
    case signature.length
      when 1: :group
      when 2: :main
      when 4: :geo
      when 8: :detail
    end
  end
  
  # Associations
  has_many :dossiers, :foreign_key => :parent_id

  def children(use_new_signature = false)
    if use_new_signature
      Dossier.where("new_signature LIKE CONCAT(?, '%')", new_signature).where("dossiers.id != ?", id)
    else
      Dossier.where("signature LIKE CONCAT(?, '%')", signature).where("dossiers.id != ?", id)
    end
  end
  
  def direct_children(use_new_signature = false)
    # TODO: support or drop new_signature
    children(use_new_signature)
  end

  # Calculations
  def document_count(use_new_signature = false)
    children(use_new_signature).includes(:numbers).sum(:amount).to_i
  end

  # Importer
  def self.import_filter
    /^[0-9][.0-9]*$/
  end

  def self.import(row)
    self.new.import(row)
  end
  
  def import(row)
    self.signature = row[0]
    self.title     = row[1]
    
    puts self unless Rails.env.test?
    return self
  end
end
