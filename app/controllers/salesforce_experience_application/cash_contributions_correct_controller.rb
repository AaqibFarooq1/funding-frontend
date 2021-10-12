class SalesforceExperienceApplication::CashContributionsCorrectController < ApplicationController
  include SfxPtsPaymentContext
  include PermissionToStartHelper

  def show
    
    @cash_contributions = 
      get_contributions(@salesforce_experience_application, true)
  
  end

  def update 
    
    @salesforce_experience_application.validate_cash_contributions_are_correct = true
    
    @salesforce_experience_application.cash_contributions_correct =
      params[:contributions_are_correct]

     if @salesforce_experience_application.valid?

      json_answers = @salesforce_experience_application.pts_answers_json

      json_answers[:cash_contributions_correct] = 
        @salesforce_experience_application.cash_contributions_correct

      @salesforce_experience_application.pts_answers_json = json_answers
      @salesforce_experience_application.save

      redirect_to(
        sfx_pts_payment_cash_contributions_evidence_path \
          (@salesforce_experience_application.salesforce_case_id)
      )

     else 

      @cash_contributions = 
        get_contributions(@salesforce_experience_application, true)

      render :show

     end

  end

end