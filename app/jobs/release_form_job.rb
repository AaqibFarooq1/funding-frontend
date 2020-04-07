class ReleaseFormJob < ApplicationJob
  queue_as :default

  # @param [Hash] params request params
  # @param [String] raw_post raw request body
  def perform(params, raw_post)
    @project = Project.find(params[:ApplicationId])
    if params[:GrantDecision] == 'Awarded' && !params[:ApprovedbyFinance]
      @project.released_forms.create(payload: raw_post, form_type: :permission_to_start)
    end
    if params[:ApprovedbyFinance]
      @project.released_forms.create(payload: raw_post, form_type: :completion_report)
    end
  end
end
