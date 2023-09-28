require "rails_helper"

RSpec.describe User, type: :model do

  describe "User model" do

    let (:resource) {
      create(
        :user,
        id: 1,
        email: 'a@f.com',
        confirmation_token: 'zsdfasd23e123',
        language_preference: "both"
      )
    } 

    it "should return the correct boolean results for the functions " \
      "that check what email language is needed " \
        "when language preferences are set to both" do
    
        expect(resource.send_bilingual_mails?).to eq(true)
        expect(resource.send_english_mails?).to eq(false)
        expect(resource.send_welsh_mails?).to eq(false)

    end

    it "should return the correct boolean results for the functions " \
    "that check what email language is needed " \
      "when language preferences are set to welsh" do

      resource.language_preference = 'welsh'  
  
      expect(resource.send_bilingual_mails?).to eq(false)
      expect(resource.send_english_mails?).to eq(false)
      expect(resource.send_welsh_mails?).to eq(true)

    end

    it "should return the correct boolean results for the functions " \
    "that check what email language is needed " \
      "when language preferences are set to english" do

      resource.language_preference = 'english'  
  
      expect(resource.send_bilingual_mails?).to eq(false)
      expect(resource.send_english_mails?).to eq(true)
      expect(resource.send_welsh_mails?).to eq(false)

    end

    it "should return true for send_english_mails " \
      "when language preferences are null" do

      resource.language_preference = nil  
  
      expect(resource.send_bilingual_mails?).to eq(false)
      expect(resource.send_english_mails?).to eq(true)
      expect(resource.send_welsh_mails?).to eq(false)

    end

    it "should return true for send_english_mails " \
      "when language preferences are null" do

        resource.language_preference = nil  

        expect(resource.send_bilingual_mails?).to eq(false)
        expect(resource.send_english_mails?).to eq(true)
        expect(resource.send_welsh_mails?).to eq(false)

    end

    it "should return the correct boolean results for the functions " \
      "that check what email language is needed " \
        "when language preferences are mixed case with extra whitespace" do

      resource.language_preference = ' eNglISh '  
      expect(resource.send_english_mails?).to eq(true)

      resource.language_preference = ' WELsh   '
      expect(resource.send_welsh_mails?).to eq(true)

      resource.language_preference = 'Both   '
      expect(resource.send_bilingual_mails?).to eq(true)
  
    end

    it "should only return true for send_english_mails? " \
      "when an unknown language preference is used." do

      resource.language_preference = 'cornish'  
      expect(resource.send_english_mails?).to eq(true)
      expect(resource.send_welsh_mails?).to eq(false)
      expect(resource.send_bilingual_mails?).to eq(false)
    end    


    context "when email is invalid" do
      let(:invalid_emails) { ['invalid', 'invalid@', 'invalid@.com', '@invalid.com', 'invalid@invalid'] }

      it "should be invalid" do
        invalid_emails.each do |email|
          resource.email = email
          expect(resource.valid?).to eq(false)
        end
      end
    end

    context "when email is valid" do
      let(:valid_emails) { ['valid@example.com', 'valid.name@example.com', 'valid.name+tag@example.co.uk', 'valid-name@example.co.uk'] }
    
      it "should be valid" do
        valid_emails.each do |email|
          resource.email = email
          expect(resource.valid?).to eq(true)
        end
      end
    end

    describe 'enum roles' do
      it 'defines enum for role with values user and admin' do
        expected_enum = {
          'user' => 0,
          'admin' => 1
        }
        expect(User.defined_enums['role']).to eq(expected_enum)
      end
    end
  
  
    describe '#set_default_role' do
      context 'when the record is new' do
        it 'sets the default role to user if role is not set' do
          user = User.new
          expect(user.role).to eq('user')
        end
  
        it 'does not override the role if it is set' do
          user = User.new(role: :admin)
          expect(user.role).to eq('admin')
        end
      end
    end

    describe 'validations' do
      context 'with validate_details set to true' do
        let(:user) { User.new(validate_details: true) }
    
        it 'validates name length between 1 and 80' do
          user.name = ''
          expect(user.valid?).to be_falsey
          expect(user.errors[:name]).to include(I18n.t("activerecord.errors.models.user.attributes.name.blank"))
    
          user.name = 'a' * 81
          expect(user.valid?).to be_falsey
          expect(user.errors[:name]).to include("Your full name must be fewer than 80 characters")
        end
    
        it 'validates presence of dob_day, dob_month, and dob_year' do
          expect(user.valid?).to be_falsey
          expect(user.errors[:dob_day]).to include(I18n.t("activerecord.errors.models.user.attributes.dob_day.blank"))
          expect(user.errors[:dob_month]).to include(I18n.t("activerecord.errors.models.user.attributes.dob_month.blank"))
          expect(user.errors[:dob_year]).to include(I18n.t("activerecord.errors.models.user.attributes.dob_year.blank"))
        end
            
        it 'validates date of birth is a date and in the past' do
          user.dob_day = 32
          user.dob_month = 12
          user.dob_year = 2000
          expect(user.valid?).to be_falsey
          expect(user.errors[:date_of_birth]).to include('Date of birth must be a valid date')
    
          user.dob_day = 10
          user.dob_month = 5
          user.dob_year = 3000
          expect(user.valid?).to be_falsey
          expect(user.errors[:date_of_birth]).to include('Date of birth must be in the past')
          
          user.dob_day = 10
          user.dob_month = 5
          user.dob_year = 1900
          expect(user.valid?).to be_falsey
          expect(user.errors[:date_of_birth]).to include(I18n.t("details.dob_error"))
        end
       
      end

    end
    
    context 'with validate_address set to true' do
      let(:user) { User.new(validate_address: true) }
  
      it 'validates presence of line1' do
        expect(user.valid?).to be_falsey
        expect(user.errors[:line1]).to include(I18n.t("activerecord.errors.models.user.attributes.line1.blank"))
      end
  
      it 'validates presence of townCity' do
        expect(user.valid?).to be_falsey
        expect(user.errors[:townCity]).to include(I18n.t("activerecord.errors.models.user.attributes.townCity.blank"))
      end
  
      it 'validates presence of county' do
        expect(user.valid?).to be_falsey
        expect(user.errors[:county]).to include(I18n.t("activerecord.errors.models.user.attributes.county.blank"))
      end
  
      it 'validates presence of postcode' do
        expect(user.valid?).to be_falsey
        expect(user.errors[:postcode]).to include(I18n.t("activerecord.errors.models.user.attributes.postcode.blank"))
      end
    end  

  end

  describe 'associations' do
    it 'has many users_organisations' do
      association = described_class.reflect_on_association(:users_organisations)
      expect(association.macro).to eq :has_many
      expect(association.options[:inverse_of]).to eq(:user)
    end

    it 'has many organisations through users_organisations' do
      association = described_class.reflect_on_association(:organisations)
      expect(association.macro).to eq :has_many
      expect(association.options[:through]).to eq(:users_organisations)
    end

    it 'has many projects' do
      expect(described_class.reflect_on_association(:projects).macro).to eq :has_many
    end

    it 'has many open_medium' do
      expect(described_class.reflect_on_association(:open_medium).macro).to eq :has_many
    end

    it 'belongs to person and it is optional' do
      association = described_class.reflect_on_association(:person)
      expect(association.macro).to eq :belongs_to
      expect(association.options[:optional]).to be_truthy
    end
  end
end
