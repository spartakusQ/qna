module ControllerHelpers
  def login(user)
    @request.env['devise.mappinf'] = Devise.mappings[:user]
    sign_in(user)
  end
end
