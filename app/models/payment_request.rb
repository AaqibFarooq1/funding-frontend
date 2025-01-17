class PaymentRequest < ApplicationRecord
  include ActiveModel::Validations, GenericValidator, ProgressAndSpendHelper

  has_many :funding_applications_pay_reqs, inverse_of: :payment_request
  has_many :funding_applications, through: :funding_applications_pay_reqs

  has_many :low_spend, dependent: :destroy
  has_many :high_spend, dependent: :destroy

  has_one_attached :table_of_spend_file

  accepts_nested_attributes_for :low_spend

  attr_accessor :higher_spend
  attr_accessor :lower_spend
  attr_accessor :no_update
  attr_accessor :validate_spend_journeys_to_do
  attr_accessor :validate_spend_journeys_to_do_40_perc
  
  attr_accessor :lower_spend_chosen
  attr_accessor :validate_lower_spend_chosen

  attr_accessor :has_bank_details_update
  attr_accessor :validate_has_bank_details_update

  attr_accessor :validate_table_of_spend_file

  attr_accessor :add_another_high_spend
  attr_accessor :validate_add_another_high_spend

  attr_accessor :add_another_low_spend
  attr_accessor :validate_add_another_low_spend

  attr_accessor :add_or_change_spend
  attr_accessor :validate_add_or_change_spend

  attr_accessor :vat_status_changed
  attr_accessor :validate_vat_status_changed
  attr_accessor :vat_number
  attr_accessor :validate_vat_number

  validates :lower_spend_chosen, presence: true, if: :validate_lower_spend_chosen?
  validates :has_bank_details_update, presence: true,  if: :validate_has_bank_details_update?
 
  validates :lower_spend_chosen, presence: true,
    if: :validate_lower_spend_chosen?

  validates :vat_number, length: { minimum: 9, maximum: 12 }, if: :validate_vat_number?

  validates_inclusion_of :add_or_change_spend, in: ["true", "false"], if: :validate_add_or_change_spend?
  validates_inclusion_of :add_another_low_spend, in: ["true", "false"], if: :validate_add_another_low_spend?
  validates_inclusion_of :vat_status_changed, in: ["true", "false"], if: :validate_vat_status_changed?

  validate do

    validate_spend_journeys_to_do_presence if \
      validate_spend_journeys_to_do || validate_spend_journeys_to_do_40_perc

    validate_add_another_high_spend_inclusion if validate_add_another_high_spend?

    validate_file_attached(
      :table_of_spend_file,
      I18n.t("activerecord.errors.models.payment_request." \
        "attributes.table_of_spend_file.inclusion")
    ) if validate_table_of_spend_file?

  end

  def validate_spend_journeys_to_do_presence

    if checkboxes_false

      errors.add(
        :spend_journeys_to_do,
        I18n.t(
          "activerecord.errors.models.payment_request." \
            "attributes.spend_journeys_to_do.blank")
      )

    end

    if no_update == 'true' && \
      (lower_spend == 'true' || \
        higher_spend == 'true')

      errors.add(
        :spend_journeys_to_do,
        I18n.t(
          "activerecord.errors.models.payment_request." \
            "attributes.spend_journeys_to_do.choose")
      )

    end

  end

  # custom validation so translation has spend_amount interpolated.
  def validate_add_another_high_spend_inclusion

    unless ['true', 'false'].include?(self.add_another_high_spend)
      errors.add(
        :add_another_high_spend,
        I18n.t(
          "activerecord.errors.models.payment_request." \
            "attributes.add_another_high_spend.inclusion",
            spend_amount: get_high_spend_threshold_from_json(self, nil)
        )
      )
    end

  end

  def validate_table_of_spend_file? 
    validate_table_of_spend_file == true
  end

  def validate_lower_spend_chosen?
    validate_lower_spend_chosen == true
  end

  def validate_has_bank_details_update?
    validate_has_bank_details_update == true
  end

  def validate_add_another_high_spend?
    validate_add_another_high_spend == true
  end

  def validate_add_another_low_spend?
    validate_add_another_low_spend == true
  end

  def validate_add_or_change_spend?
    validate_add_or_change_spend == true
  end

  def validate_vat_status_changed?
    validate_vat_status_changed == true
  end

  def validate_vat_number?
    validate_vat_number == true
  end

  # Validates at least one checkbox is checked
  # when no_update is both present (on arrears journey) 
  # and not present (on a M1 40% payment journey).
  def checkboxes_false

    return higher_spend == 'false' && \
      lower_spend == 'false' && \
        no_update == 'false' \
          if validate_spend_journeys_to_do

    return higher_spend == 'false' && \
      lower_spend == 'false' \
        if validate_spend_journeys_to_do_40_perc

  end

end
