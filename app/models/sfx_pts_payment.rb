# This encapsulates the permission to start and payments data needed to 
# process a large application started in Salesforce Experience.
class SfxPtsPayment < ApplicationRecord
	include GenericValidator

	attr_accessor :validate_approved_purposes_match    
	attr_accessor :validate_agreed_costs_match
	attr_accessor :validate_agreed_costs_files
	attr_accessor :validate_has_agreed_costs_docs
	attr_accessor :validate_cash_contributions_correct
	attr_accessor :validate_non_cash_contributions_correct
	attr_accessor :validate_permissions_or_licences_received
	attr_accessor :validate_agrees_to_declaration
	attr_accessor :validate_cash_contributions_evidence_question
	attr_accessor :validate_cash_contributions_evidence_files
	attr_accessor :validate_fundraising_evidence_question
	attr_accessor :validate_fundraising_evidence_files
	attr_accessor :validate_legal_sig_one
	attr_accessor :validate_legal_sig_two
	attr_accessor :validate_partnership_application
	attr_accessor :validate_project_partner_name
	attr_accessor :validate_timetable_work_programme_question
	attr_accessor :validate_timetable_work_programme_files
	attr_accessor :validate_project_management_structure_question
	attr_accessor :validate_project_management_structure_files
	attr_accessor :validate_property_ownership_evidence_question
	attr_accessor :validate_property_ownership_evidence_files
	attr_accessor :validate_add_another_statutory_permission_or_licence
	attr_accessor :validate_pts_form_files

	attr_accessor :approved_purposes_match
	attr_accessor :agreed_costs_match
	attr_accessor :has_agreed_costs_docs
	attr_accessor :cash_contributions_correct
	attr_accessor :non_cash_contributions_correct
	attr_accessor :permissions_or_licences_received
	attr_accessor :agrees_to_declaration
	attr_accessor :cash_contributions_evidence_question
	attr_accessor :fundraising_evidence_question
	attr_accessor :legal_sig_one
	attr_accessor :legal_sig_two
	attr_accessor :partnership_application
	attr_accessor :project_partner_name
	attr_accessor :timetable_work_programme_question
	attr_accessor :project_management_structure_question
	attr_accessor :property_ownership_evidence_question
	attr_accessor :add_another_statutory_permission_or_licence

	has_many :statutory_permission_or_licence
	has_many_attached :agreed_costs_files
	has_many_attached :cash_contributions_evidence_files
	has_many_attached :fundraising_evidence_files
	has_many_attached :timetable_work_programme_files
	has_many_attached :project_management_structure_files
	has_many_attached :property_ownership_evidence_files
	has_many_attached :pts_form_files

	validates :approved_purposes_match, presence: true, if: :validate_approved_purposes_match?
	validates :agreed_costs_match, presence: true, if: :validate_agreed_costs_match?
	validates :has_agreed_costs_docs, presence: true, if: :validate_has_agreed_costs_docs?
	validates :cash_contributions_correct, presence: true, if: :validate_cash_contributions_correct?
	validates :non_cash_contributions_correct, presence: true, if: :validate_non_cash_contributions_correct?
	validates :permissions_or_licences_received, presence: true, if: :validate_permissions_or_licences_received?
	validates :agrees_to_declaration, presence: true, if: :validate_agrees_to_declaration?
	validates :cash_contributions_evidence_question, presence: true, 
		if: :validate_cash_contributions_evidence_question?
	validates :fundraising_evidence_question, presence: true, 
		if: :validate_fundraising_evidence_question?
	validates :legal_sig_one, presence: true, if: :validate_legal_sig_one?
	validates :legal_sig_two, presence: true, if: :validate_legal_sig_two?
	validates :partnership_application, presence: true, if: :validate_partnership_application?
	validates :project_partner_name, presence: true, if: :validate_project_partner_name?
	validates :timetable_work_programme_question, presence: true, 
		if: :validate_timetable_work_programme_question?
	validates :project_management_structure_question, presence: true, 
		if: :validate_project_management_structure_question?
	validates :property_ownership_evidence_question, presence: true, 
		if: :validate_property_ownership_evidence_question?
	validates :add_another_statutory_permission_or_licence, presence: true, 
		if: :validate_add_another_statutory_permission_or_licence?

	validate do

		validate_file_attached(
				:agreed_costs_files,
				I18n.t("activerecord.errors.models.sfx_pts_payment.attributes.agreed_costs_files.inclusion")
		) if validate_agreed_costs_files?

		validate_file_attached(
			:cash_contributions_evidence_files,
			I18n.t('activerecord.errors.models.sfx_pts_payment.attributes.' \
				'cash_contributions_evidence_files.inclusion')
		) if validate_cash_contributions_evidence_files?

		validate_file_attached(
			:fundraising_evidence_files,
			I18n.t('activerecord.errors.models.sfx_pts_payment.attributes.' \
				'fundraising_evidence_files.inclusion')
		) if validate_fundraising_evidence_files?

		validate_file_attached(
			:timetable_work_programme_files,
			I18n.t('activerecord.errors.models.sfx_pts_payment.attributes.' \
				'timetable_work_programme_files.inclusion')
		) if validate_timetable_work_programme_files?

		validate_file_attached(
			:project_management_structure_files,
			I18n.t('activerecord.errors.models.sfx_pts_payment.attributes.' \
				'project_management_structure_files.inclusion')
		) if validate_project_management_structure_files?

		validate_file_attached(
			:property_ownership_evidence_files,
			I18n.t('activerecord.errors.models.sfx_pts_payment.attributes.' \
				'property_ownership_evidence_files.inclusion')
		) if validate_property_ownership_evidence_files?

		validate_file_attached(
			:pts_form_files,
			I18n.t("activerecord.errors.models.sfx_pts_payment.attributes.pts_form_files.inclusion")
	) if validate_pts_form_files?

	end

	def validate_approved_purposes_match?
		validate_approved_purposes_match == true
	end

	def validate_agreed_costs_match?
		validate_agreed_costs_match == true
	end

	def validate_has_agreed_costs_docs?
		validate_has_agreed_costs_docs == true
	end

	def validate_agreed_costs_files?
		validate_agreed_costs_files == true
	end

	def validate_cash_contributions_correct?
		validate_cash_contributions_correct == true
	end

	def validate_non_cash_contributions_correct?
		validate_non_cash_contributions_correct == true
	end

	def validate_permissions_or_licences_received?
		validate_permissions_or_licences_received == true
	end

	def validate_agrees_to_declaration?
		validate_agrees_to_declaration == true
	end

	def validate_cash_contributions_evidence_files?
		validate_cash_contributions_evidence_files == true
	end

	def validate_cash_contributions_evidence_question?
		validate_cash_contributions_evidence_question == true
	end

	def validate_fundraising_evidence_files?
		validate_fundraising_evidence_files == true
	end

	def validate_fundraising_evidence_question?
		validate_fundraising_evidence_question == true
	end

	def validate_legal_sig_one? 
		validate_legal_sig_one == true
	end

	def validate_legal_sig_two?
		validate_legal_sig_two == true
	end

	def validate_partnership_application?
		validate_partnership_application == true
	end

	def validate_project_partner_name? 
		validate_project_partner_name == true
	end

	def validate_timetable_work_programme_files?
		validate_timetable_work_programme_files == true
	end

	def validate_timetable_work_programme_question?
		validate_timetable_work_programme_question == true
	end

	def validate_project_management_structure_files?
		validate_project_management_structure_files == true
	end

	def validate_project_management_structure_question?
		validate_project_management_structure_question == true
	end

	def validate_property_ownership_evidence_files?
		validate_property_ownership_evidence_files == true
	end

	def validate_property_ownership_evidence_question?
		validate_property_ownership_evidence_question == true
	end

	def validate_add_another_statutory_permission_or_licence?
		validate_add_another_statutory_permission_or_licence == true
	end
	
	def validate_pts_form_files?
		validate_pts_form_files == true
	end

	enum application_type: {
		large_delivery: 0,
		large_development: 1,
		unknown: 2
	}

end
