module Fastly::ServiceVersionModel
  attr_reader :cistern

  def service
    @_service ||= begin
                    requires :service_id

                    cistern.services.get(service_id)
                  end
  end

  def version
    @_version ||= begin
                    requires :service_id, :version_number

                    cistern.versions(service_id: service_id).get(version_number)
                  end
  end

  protected

  def merge_attributes(new_attributes={})
    @cistern ||= new_attributes.delete(:service)
    super(new_attributes)
  end

end
