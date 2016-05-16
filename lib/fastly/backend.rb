class Fastly::Backend < Fastly::Model
  include Fastly::ServiceVersionModel

  identity :id, alias: "name", type: :string

  attribute :address, type: :string                           # An hostname, IPv4, or IPv6 address for the backend.
  attribute :auto_loadbalance, type: :boolean                 # Whether or not this backend should be automatically load balanced.
  attribute :between_bytes_timeout, type: :integer            # How long to wait between bytes in milliseconds.
  attribute :client_cert, type: :string
  attribute :comment, type: :string
  attribute :connect_timeout, type: :integer                  # How long to wait for a timeout in milliseconds.
  attribute :error_threshold, type: :integer                  # Number of errors to allow before the backend is marked as down.
  attribute :first_byte_timeout, type: :integer               # How long to wait for the first bytes in milliseconds.
  attribute :healthcheck, type: :string                       # The name of the healthcheck to use with this backend. Can be empty.
  attribute :hostname, type: :string                          # The hostname of the backend.
  attribute :ipv4, type: :string                              # IPv4 address of the host.
  attribute :ipv6, type: :string                              # IPv6 address of the host.
  attribute :locked, type: :boolean                           # Specifies whether or not the version is locked for editing.
  attribute :max_conn, type: :integer                         # Maximum number of connections.
  attribute :max_tls_version, type: :integer                  # Maximum allowed TLS version on SSL connections to this backend.
  attribute :min_tls_version, type: :integer                  # Minimum allowed TLS version on SSL connections to this backend.
  attribute :name, type: :string                              # The name of the backend.
  attribute :port, type: :integer                             # The port number.
  attribute :request_condition, type: :string                 # Condition, which if met, will select this backend during a request.
  attribute :service_id, type: :string                        # The alphanumeric string identifying a service.
  attribute :shield, type: :string                            # The shield POP designated to reduce inbound load on this origin by serving the cached data to the rest of the network.
  attribute :ssl_ca_cert, type: :string                       # CA certificate attached to origin.
  attribute :ssl_cert_hostname, type: :string                 # Overrides ssl_hostname, but only for cert verification. Does not affect SNI at all.
  attribute :ssl_check_cert, type: :boolean                   # Be strict on checking SSL certs.
  attribute :ssl_ciphers, type: :string                       # List of openssl ciphers (see https://www.openssl.org/docs/manmaster/apps/ciphers.html for details)
  attribute :ssl_client_cert, type: :string                   # Client certificate attached to origin.
  attribute :ssl_client_key, type: :string                    # Client key attached to origin.
  attribute :ssl_hostname, type: :string                      # Used for both SNI during the TLS handshake and to validate the cert.
  attribute :ssl_sni_hostname, type: :string                  # Overrides ssl_hostname, but only for SNI in the handshake. Does not affect cert validation at all.
  attribute :use_ssl, type: :boolean                          # Whether or not to use SSL to reach the backend.
  attribute :version_number, type: :integer, alias: "version" # The current version number of a service.
  attribute :weight, type: :integer                           # Weight used to load balance this backend against others.

  def reload
    requires :service_id, :version_number, :identity

    @_service = nil
    @_version = nil

    merge_attributes(
      cistern.backends(service_id: service_id, version: version).get(identity).attributes
    )
  end

  def create
    requires :service_id, :version_number, :name

    response = cistern.create_backend(service_id, version_number, attributes)
    merge_attributes(response.body)
  end

  def save
    requires :service_id, :version_number, :identity

    response = cistern.update_backend(service_id, version_number, name, attributes)
    merge_attributes(response.body)
  end

end
