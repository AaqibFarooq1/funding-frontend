module UserHelper

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

  # populates passed user with salesforce contact
  # @param [User] user An instance of User
  # @param [String] salesforce_contact_id Reference for Salesforce contact
  def populate_user_from_salesforce(user, salesforce_contact_id)

    contact_restforce =
      retrieve_existing_salesforce_contact(salesforce_contact_id)

    populate_user_from_restforce_object(user, contact_restforce)

  end

  private

  # Takes a Restforce collection for a Contact, and populates a User from it.
  # @param [User] user An instance of User (FFE)
  # @param [RestforceResponse] restforce_object A restforce collection frm SF.
  def populate_user_from_restforce_object(user, restforce_object)

    Rails.logger.info("Starting to populate " \
      "User id: #{user.id} from SF contact: #{restforce_object.Id}")

    lines_array = ['', '', '']

    # MailingAddress nil when Account created with no address
    unless restforce_object.MailingAddress&.street&.nil?
      lines_array =
        restforce_object.MailingAddress.street.split(
          /\s*,\s*/
        )
    end

    user.line1 = lines_array[0]
    user.line2 = lines_array[1]
    user.line3 = lines_array[2]
    user.townCity = restforce_object.MailingAddress.city
    user.county = restforce_object.MailingAddress.state
    user.postcode = restforce_object.MailingAddress.postalCode

    user.name =
      [
        restforce_object.FirstName || '',
        restforce_object.MiddleName || '',
        restforce_object.LastName || ''
      ].reject(&:empty?).join(' ') # SF names together, space delimited

    user.phone_number =
      restforce_object.Phone.present? ? restforce_object.Phone :
        (restforce_object.MobilePhone || '') # get mobile if no phone.

    user.date_of_birth = restforce_object.Birthdate
    user.language_preference = restforce_object.Language_Preference__c
    user.salesforce_contact_id = restforce_object.Id
    user.agrees_to_user_research = restforce_object.Agrees_To_User_Research__c
    user.communication_needs = restforce_object.Other_communication_needs_for_contact__c
    user.save

    Rails.logger.info("Successfully populated " \
      "User id: #{user.id} from SF contact: #{restforce_object.Id}")

  end

  # Checks for the presence of an associated Address via the PeopleAddresses
  # model. If none exists, a new Address and PeopleAddress is created. Address
  # details are replicated from the current_user object
  #
  # @param [User] user An instance of User
  def check_and_set_person_address(user)

    person_address_association = PeopleAddress.find_by(person_id: user.person_id)

    unless person_address_association

      logger.debug "No people_addresses record found for person ID: #{user.person_id}"

      address = Address.create

      logger.debug "addresses record created with ID: #{address.id}"

      person_address_association = create_person_address_association(user.person_id, address.id)

    end

    replicate_address_from_current_user_details(person_address_association.address_id, user)

  end

  # Creates and returns a PeopleAddress object based on the
  # Address and User arguments passed
  #
  # @param [uuid] person_id The unique identifier of a Person
  # @param [uuid] address_id The unique identifier of an Address
  def create_person_address_association(person_id, address_id)

    logger.debug "Creating people_addresses record for person ID: #{person_id} " \
      "and address ID: #{address_id}"

    person_address_association = PeopleAddress.create(
      person_id: person_id,
      address_id: address_id
    )

    logger.debug "people_addresses record created with ID: #{person_address_association.id}"

    person_address_association

  end

  # Creates and returns a new Address object based on the
  # attributes stored against the User argument
  #
  # @param [uuid] id The unique identifier of an Address
  # @param [User] user An instance of User
  def replicate_address_from_current_user_details(id, user)

    address = Address.find(id)

    address.update(
      line1: user.line1,
      line2: user.line2,
      line3: user.line3,
      town_city: user.townCity,
      county: user.county,
      postcode: user.postcode
    )

  end

  # Replicates a subset of attributes from the passed in User object
  # to the User's associated Person record
  #
  # @param [User] user An instance of User
  def replicate_user_attributes_to_associated_person(user)

    person = Person.find(user.person_id)

    person.update(
      name: user.name,
      date_of_birth: user.date_of_birth,
      phone_number: user.phone_number
    )

  end

end