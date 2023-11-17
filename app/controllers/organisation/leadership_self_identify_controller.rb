# Controller for a page that asks an how an organisations leadership self idenifies.
class Organisation::LeadershipSelfIdentifyController < ApplicationController
  include OrganisationContext
  include ObjectErrorsLogger

  # This method updates the leadership_self_identify attributes
  # of an organisation redirecting to :charity_number if successful and
  # re-rendering the :show method if unsuccessful
  def update
    logger.info "Updating leadership_self_identify for organisation ID: #{@organisation.id}"

    @organisation.validate_leadership_self_identify = true

    @organisation.update(organisation_params)

    if @organisation.valid?
      logger.info "Finished updating leadership_self_identify for organisation ID: #{@organisation.id}"
      redirect_to organisation_charity_number_path
    else
      log_errors(@organisation)
      render :show
    end
  end

  private

  def organisation_params
    params.fetch(:organisation, {}).permit(leadership_self_identify: [])
  end

end