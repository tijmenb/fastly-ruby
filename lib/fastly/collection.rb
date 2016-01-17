class Fastly::Collection
  def first(*args)
    all(*args).records.first
  end

  def last(*args)
    all(*args).records.last
  end
end
