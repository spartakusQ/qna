module ControllerHelpers
  def login(user)
    @request.env['devise.mappinf'] = Devise.mappings[:user]
    sign_in(user)
  end

  def attach_file_to(model)
    model.files.attach(io: File.open("#{Rails.root.join('spec/rails_helper.rb')}"), filename: 'rails_helper.rb')
  end
end
