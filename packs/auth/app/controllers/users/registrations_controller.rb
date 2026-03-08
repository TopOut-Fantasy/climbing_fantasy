module Users
  class RegistrationsController < Devise::RegistrationsController
    layout "auth"

    private

    # Devise requires these to return ActionController::Parameters;
    # params.expect returns an array for scalar keys, which breaks Devise internals.
    def sign_up_params
      params.require(:user).permit(:email, :password, :password_confirmation, :display_name) # rubocop:disable Rails/StrongParametersExpect
    end

    def account_update_params
      params.require(:user).permit(:email, :password, :password_confirmation, :current_password, :display_name) # rubocop:disable Rails/StrongParametersExpect
    end
  end
end
