class Fastly::ServiceVersion < Fastly::Model

  identity :id

  attribute :number, type: :integer #  The number of this version.
  attribute :active, type: :boolean #   Whether this is the active version or not.
  attribute :locked, type: :boolean # Whether this version is locked or not. Objects can not be added or edited on locked versions.


end
