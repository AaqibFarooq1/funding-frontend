class Project::LocationController < ApplicationController
  include ProjectContext

  def update

    @project.validate_same_location = true

    @project.update(project_params)

    if @project.valid?

      if @project.same_location == "yes"

        logger.debug "Same location as organisation selected for project ID: #{@project.id}"

        add_project_address_fields

        @project.save

        logger.debug "Finished updating location for project ID: #{@project.id}"

        redirect_to :three_to_ten_k_project_description

      else

        logger.debug "Different location to organisation selected for project ID: #{@project.id}"

        redirect_to postcode_path 'project', @project.id

      end

    else

      render :show

    end

  end

  private

  def project_params

    unless params[:project].present?
      params.merge!({project: {same_location: ""}})
    end

    params.require(:project).permit(:same_location, :line1, :line2, :line3, :townCity, :county, :postcode)
  end

  # Replicates address data from the organisation model linked to the current user
  # into the project model address fields
  def add_project_address_fields

    logger.debug "Setting project address fields for project ID: #{@project.id}"

    @organisation = Organisation.find(current_user.organisation.id)

    @project.line1 = @organisation.line1
    @project.line2 = @organisation.line2
    @project.line3 = @organisation.line3
    @project.townCity = @organisation.townCity
    @project.county = @organisation.county
    @project.postcode = @organisation.postcode

    logger.debug "Finished setting project address fields for project ID: #{@project.id}"

  end

end
