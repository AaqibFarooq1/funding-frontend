require 'rails_helper'

RSpec.describe PreApplication::ExpressionOfInterest::StartController do

  login_user

  describe 'PUT #update' do

    it 'should call orchestrate_expression_of_interest_start_journey ' \
      'with the current_user' do

      expect(controller).to receive(
        :orchestrate_expression_of_interest_start_journey
      ).with(subject.current_user)

      put :update

    end


    it 'should create an organisation and redirect to :postcode path ' \
      'if no organisation existed and import_existing_account enabled' do

      begin
        
        Flipper[:import_existing_account_enabled].enable

        subject.current_user.organisations.clear

        put :update

        expect(subject.current_user.organisations.count).to(eq(1))

        # Expect that a PreApplication and an associated PaExpressionOfInterest
        # have been created
        expect(assigns(:pre_application)).not_to(be_nil)
        expect(assigns(:pre_application).pa_expression_of_interest).not_to(be_nil)
        expect(assigns(:pre_application).user).not_to(be_nil)

        expect(response).to have_http_status(:redirect)

        expect(response).to(
          redirect_to(
            postcode_path(
              'preapplication',
              id: assigns(:pre_application).id
            )
          )
        )
        
      ensure
        Flipper[:import_existing_account_enabled].disable
      end    

    end

    it 'should redirect to organisation :postcode path for an incomplete organisation ' \
      'and import_existing_account enabled' do

      begin
        
        Flipper[:import_existing_account_enabled].enable

        put :update

        # Expect that a PreApplication and an associated PaExpressionOfInterest
        # have been created
        expect(assigns(:pre_application)).not_to(be_nil)
        expect(assigns(:pre_application).pa_expression_of_interest).not_to(be_nil)
        expect(assigns(:pre_application).user).not_to(be_nil)

        expect(response).to have_http_status(:redirect)

        expect(response).to(
          redirect_to(
            postcode_path(
              'preapplication',
              id: assigns(:pre_application).id
            )
          )
        )

      ensure
        Flipper[:import_existing_account_enabled].disable
      end      

    end

    it 'should redirect to the pa_expression_of_interest path for a complete ' do
      'organisation'

      subject.current_user.organisations.first.update(
        name: 'Test Organisation',
        line1: '10 Downing Street',
        line2: 'Westminster',
        townCity: 'London',
        county: 'London',
        postcode: 'SW1A 2AA',
        org_type: 1
      )

      put :update

      # Expect that a PreApplication and an associated PaExpressionOfInterest
      # have been created
      expect(assigns(:pre_application)).not_to(be_nil)
      expect(assigns(:pre_application).pa_expression_of_interest).not_to(be_nil)
      expect(assigns(:pre_application).user).not_to(be_nil)

      expect(response).to have_http_status(:redirect)

      expect(response).to(
        redirect_to(
          pre_application_expression_of_interest_previous_contact_path(
            pre_application_id: assigns(:pre_application).id
          )
        )
      )

    end

  end

end
