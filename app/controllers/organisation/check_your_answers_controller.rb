# Controller for a page that asks for summary information about an organisation.
class Organisation::CheckYourAnswersController < ApplicationController
  include OrganisationContext

  def update

    redirect_to :authenticated_root
        
  end

end