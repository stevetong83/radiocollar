class String
  def short_url
    MongoidShortener.generate(self)
  end
end