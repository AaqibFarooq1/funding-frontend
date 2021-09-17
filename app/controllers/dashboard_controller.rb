  # Controller for the service dashboard page
class DashboardController < ApplicationController
  before_action :authenticate_user!
  include DashboardHelper

  def show

    if user_details_complete(current_user)

      salesforce_api_instance = get_salesforce_api_instance()

      gon.push({ tracking_url_path: '/project-dashboard' })

      @projects = current_user.projects

      # A user may not have an associated organisation at this point
      if current_user.organisations.any?

        @funding_applications = current_user.organisations.first.funding_applications

        if @funding_applications.present?

          # For these hashes, a FundingApplication will be key
          # A boolean on whether payment can start will be value
          @gp_open_smalls = []
          @gp_open_mediums = []
          @legally_agreed_smalls = []
          @legally_agreed_mediums = []
          @large_applications = []

          @funding_applications.each do |funding_application|

            @gp_open_smalls.push(funding_application) \
              if funding_application.project.present? && \
                !awarded(funding_application, salesforce_api_instance)

            @gp_open_mediums.push(funding_application) \
              if funding_application.open_medium.present? && \
                !awarded(funding_application, salesforce_api_instance)
            
            @legally_agreed_smalls.push(funding_application) \
              if funding_application.project.present? && \
                awarded(funding_application, salesforce_api_instance)

            @legally_agreed_mediums.push(funding_application) \
            if funding_application.open_medium.present? && \
              awarded(funding_application, salesforce_api_instance)

          end

        end

        @pre_applications = current_user.organisations.first.pre_applications

        @pa_project_enquiry_presence = get_pa_project_enquiry_presence(@pre_applications)
        @pa_expression_of_interest_presence = get_pa_expression_of_interest_presence(@pre_applications)
        
        @large_applications = get_large_salesforce_applications(salesforce_api_instance, current_user.email)

        @large_applications = get_large_salesforce_applications(salesforce_api_instance, current_user.email)

      end

    else

      redirect_to(:user_details)

    end

  end

  # Early users of the service may not have an organisation linked to their
  # user account. Because of this, we need to check for an organisation and
  # create one if none is present. We also check for the mandatory
  # organisation details to be complete before we can allow a user to
  # create a new application.
  def orchestrate_dashboard_journey

    create_organisation_if_none_exists(current_user)

    redirect_based_on_organisation_completeness(current_user.organisations.first)

  end

  private

  # Determines whether a pa_project_enquiry object association
  # exists within a collection of PreApplication objects
  #
  # @param [ActiveRecord::Collection] pre_applications A collection of pre_applications
  def get_pa_project_enquiry_presence(pre_applications)

    presence = false

    pre_applications.each do |pa|
      if pa.pa_project_enquiry.present?
        presence = true
        break
      end
    end

    presence

  end

  # Determines whether a pa_expression_of_interest object association
  # exists within a collection of PreApplication objects
  #
  # @param [ActiveRecord::Collection] pre_applications A collection of pre_applications
  def get_pa_expression_of_interest_presence(pre_applications)

    presence = false

    pre_applications.each do |pa|
      if pa.pa_expression_of_interest.present?
        presence = true
        break
      end
    end

    presence

  end

  # Checks for the presence of mandatory fields on a given user.
  # Returns true if all mandatory fields are present, otherwise
  # returns false.
  #
  # @param [User] user An instance of User
  def user_details_complete(user)

    user_details_fields_presence = []

    user_details_fields_presence.push(user.name.present?)
    user_details_fields_presence.push(user.date_of_birth.present?)
    user_details_fields_presence.push(
      (
        user.line1.present? &&
        user.townCity.present? &&
        user.county.present? &&
        user.postcode.present?
      )
    )

    user_details_fields_presence.all?

  end

  # Checks for the presence of an organisation associated to a user
  # and creates one if none exists
  #
  # @param [User] user An instance of User
  def create_organisation_if_none_exists(user)

    # rubocop:disable Style/GuardClause
    unless user.organisations.any?

      logger.info "No organisation found for user ID: #{user.id}"

      create_organisation(user)

    end
    # rubocop:enable Style/GuardClause

  end

  # Creates an organisation and links this to the current_user
  #
  # @param [User] user An instance of User
  def create_organisation(user)

    user.organisations.create

    logger.info "Successfully created organisation ID: #{user.organisations.first.id}"

  end

  # Redirects the user based on the completeness of their associated organisation
  # If complete, we redirect to new_application_path, otherwise if an organisation
  # is missing mandatory details, we redirect to the first page of the organisation
  # section of the service
  #
  # @param [Organisation] organisation An instance of Organisation
  def redirect_based_on_organisation_completeness(organisation)

    if helpers.complete_organisation_details?(organisation)

      logger.info "Organisation details complete for #{organisation.id}"

      redirect_to(:start_an_application)

    else

      logger.info "Organisation details not complete for #{organisation.id}"

      redirect_to organisation_type_path(organisation.id)

    end

  end

end
