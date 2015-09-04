module AsUserAssociationExtension
  def created_by?(user)
    self.user == user
  end
end