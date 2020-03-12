class Project::CheckAnswersController < ApplicationController
  include ProjectContext, ObjectErrorsLogger

  # This method redirects a user based on whether or not the mandatory project
  # fields have been populated, redirecting where necessary based on the
  # organisation type if successful, or re-rendering :show method if
  # unsuccessful
  def update

    logger.info "Determining state of application before proceeding to " \
                "declaration route for project ID: #{@project.id}"

    @project.validate_check_your_answers = true

    if @project.valid?

      logger.info "All mandatory fields completed for project ID: " \
                  "#{@project.id}"

      if current_user.organisation.org_type == "registered_company" ||
          current_user.organisation.org_type ==
              "individual_private_owner_of_heritage"

        logger.info "Organisation is either a registered company or an " \
                    "individual private owner of heritage, redirecting to " \
                    "declaration page"

        redirect_to :three_to_ten_k_project_confirm_declaration_get

      else

        logger.info "Redirecting to governing documents page"

        redirect_to :three_to_ten_k_project_governing_docs_get

      end

    else

      logger.info "Validation failed when 'Check your answers' " \
                    "form was submitted for project ID: #{@project.id}"

      log_errors(@project)

      render :show

    end

  end

end
