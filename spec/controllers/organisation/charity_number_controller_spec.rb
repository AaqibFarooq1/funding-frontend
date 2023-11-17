require "rails_helper"

RSpec.describe Organisation::CharityNumberController do
  login_user

  describe "GET #show" do

    it "should render the page successfully for a valid organisation" do
      get :show,
          params: { organisation_id: subject.current_user.organisations.first.id }
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:show)
      expect(assigns(:organisation).errors.empty?).to eq(true)
    end

    it "should redirect to root for an invalid organisation" do
      get :show, params: { organisation_id: "invalid" }
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(:root)
    end

  end

  describe "PUT #update" do

    it "should raise an exception based on strong params validation if no " \
       "params are passed" do
      expect {
        put :update,
            params: { organisation_id: subject.current_user.organisations.first.id }
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(:organisation_signatories)
      }.to raise_error(
               ActionController::ParameterMissing,
               "param is missing or the value is empty: organisation"
           )
    end

    it "should raise an exception based on strong params validation if an " \
       "empty organisation param is passed" do
      expect {
        put :update,
            params: {
                organisation_id: subject.current_user.organisations.first.id,
                organisation: {}
            }
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(:organisation_signatories)
      }.to raise_error(
               ActionController::ParameterMissing,
               "param is missing or the value is empty: organisation"
           )
    end

    it "should successfully redirect if an empty charity_number " \
    "param is passed" do
 
      put :update, params: {
          organisation_id: subject.current_user.organisations.first.id,
          organisation: {
              charity_number: "",
              has_charity_number: "no" 
          }
      }
    
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(
          organisation_company_number_path(
              subject.current_user.organisations.first.id
          )
      )
      expect(assigns(:organisation).errors.empty?).to eq(true)
    end
 

    it "should successfully redirect if a populated charity_number " \
    "param is passed" do
 
      put :update, params: {
          organisation_id: subject.current_user.organisations.first.id,
          organisation: {
              charity_number: "CHNO12345",
              has_charity_number: "yes" 
          }
      }
    
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(
          organisation_company_number_path(
              subject.current_user.organisations.first.id
          )
      )
      expect(assigns(:organisation).errors.empty?).to eq(true)
      expect(assigns(:organisation).charity_number).to eq("CHNO12345")
    end
    

    it "should re-render the show page with errors if the " \
    "charity number exceeds 20 characters" do

      put :update, params: {
          organisation_id: subject.current_user.organisations.first.id,
          organisation: {
              charity_number: "CHNO123456789123456789",
              has_charity_number: "yes" 
          }
      }

      expect(assigns(:organisation).charity_number).to eq("CHNO123456789123456789")
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:show)
      expect(assigns(:organisation).errors.present?).to eq(true)
      expect(
        assigns(:organisation).errors.messages[:charity_number][0]
      ).to eq(I18n.t("activerecord.errors.models.organisation.attributes." \
        "charity_number.too_long"))


    end

  end

end