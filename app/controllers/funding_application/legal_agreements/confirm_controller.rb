require 'bcrypt'

class FundingApplication::LegalAgreements::ConfirmController < ApplicationController
  include FundingApplicationContext
  include FundingApplicationHelper
  include ObjectErrorsLogger
  include LegalAgreementsHelper

  def update

    @funding_application.agreement.update(grant_agreed_at: DateTime.now)

    if @funding_application.funding_applications_legal_sigs.empty?

      create_legal_signatory_agreements(@funding_application)

      trigger_legal_signatory_emails(
        @funding_application,
        current_user
      )

    end

    upload_additional_evidence_files(@funding_application) if
      @funding_application.additional_evidence_files.any?

    redirect_to(:funding_application_terms_and_conditions)

  end

    # Method responsible for orchestrating sending emails to Legal Signatories
  #
  # @param [FundingApplication] funding_application An instance of
  #                             FundingApplication
  # @param [User] current_user An instance of User
  def trigger_legal_signatory_emails(
    funding_application,
    current_user
  )

    if is_applicant_legal_signatory?(
      funding_application, current_user
    )

      # Here we are retrieving the LegalSignatory whose email address is not
      # a match for the current user's (applicant's) email address. If, in
      # the future, we associate more than two legal signatories with an
      # organisation then this will need to change
      recipient =
        funding_application.organisation.legal_signatories.where
        .not(email_address: current_user.email)[0]


      # If there is only one legal signatory that is also the applicant - 
      # this recipient will be nil.  
      if recipient.present?

        encoded_signatory_id = encode_legal_signatory_id(recipient.id)

        agreement_link = build_agreement_link(
          funding_application.id,
          encoded_signatory_id
        )
        
        send_both_signatory_link_emails(recipient.email_address, funding_application,
          agreement_link)

      end

    else

      funding_application.organisation.legal_signatories.each do |ls|

        encoded_signatory_id = encode_legal_signatory_id(ls.id)

        agreement_link = build_agreement_link(
          funding_application.id,
          encoded_signatory_id
        )

        send_both_signatory_link_emails(ls.email_address, funding_application,
          agreement_link)

      end

    end

  end

  private

  # Method responsible for creating new FundingApplicationsLegalSigs objects
  #
  # @param [FundingApplication] funding_application An instance of
  #                                                 FundingApplication
  def create_legal_signatory_agreements(funding_application)

    funding_application.organisation.legal_signatories.each do |ls|

      funding_application.funding_applications_legal_sigs.create(
        legal_signatory_id: ls.id
      )

    end

  end

  # Method responsible for building a URL to 'Check project details' page
  # of the legal agreement journey for a Legal Signatory
  #
  # @param [String] funding_application_id UUID for a FundingApplication
  # @param [String] encoded_signatory_id An encoded UUID for a LegalSignatory
  #
  # @return [String] The URL to the 'Check project details' page
  def build_agreement_link(funding_application_id, encoded_signatory_id)

    url_for(
      controller: '/funding_application/legal_agreements/signatories/check_details',
      encoded_signatory_id: encoded_signatory_id,
      action: 'show',
    )

  end

  # Method responsible for orchestrating sig email to  
  # signatory and support for auditing/record.
  #
  # @param [String] email_address Email address of signatory. 
  # @param [FundingApplication] funding_application FundingApplication that requires legal signatures
  # @param [String] agreement_link URL encoded agreement link to be emailed
  #
  # @return [String] The URL to the 'Check project details' page
  def send_both_signatory_link_emails(email_address, funding_application,
    agreement_link)
    
    # send to applicant
    send_legal_signatory_email(email_address, funding_application,
      agreement_link, ".")

    # copy to support
    send_legal_signatory_email(Rails.configuration.x.no_reply_email_address,
      funding_application, agreement_link, " FAO - #{email_address}")

  end

  # Abstracted method that implements notfiy mailer to send 
  # signatory emails containing magic link
  #
  # @param [String] email_address Email address of signatory. 
  # @param [FundingApplication] funding_application FundingApplication that requires legal signatures
  # @param [String] agreement_link URL encoded agreement link to be emailed
  # @param [String] fao_email email to attach to subject if sent to support. 
  #
  # @return [String] The URL to the 'Check project details' page
  def send_legal_signatory_email(email_address, funding_application, agreement_link, fao_email)
    NotifyMailer.legal_signatory_agreement_link(
      email_address,
      funding_application.id,
      agreement_link,
      funding_application.project.present? ?
        funding_application.project.project_title :
        funding_application.open_medium.project_title,
      funding_application.project_reference_number,
      funding_application.organisation.name,
      fao_email
    ).deliver_later()
  end

end
