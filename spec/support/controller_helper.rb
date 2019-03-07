module ControllerHelpers
  def login(user)
    @request.env['devise.mappinf'] = Devise.mappings[:user]
    sign_in(user)
  end

  def attach_file_to(model)
    model.files.attach(io: File.open("#{Rails.root.join('spec/rails_helper.rb')}"), filename: 'rails_helper.rb')
  end

  def voted(model, user)
    if model.to_s == 'Answer'
      question = create(:question, user: user)
      create(model.to_s.underscore.to_sym, question: question, user: user)
    else
      create(model.to_s.underscore.to_sym, user: user)
    end
  end
end
