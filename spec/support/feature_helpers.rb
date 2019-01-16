module FeatureHelpers
  def sign_in(user)
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'
  end

  def add_file_to(model)
    model.files.attach(io: File.open("#{Rails.root.join('spec/rails_helper.rb')}"), filename: 'rails_helper.rb')
  end

  def add_image_to(badge)
    badge.image.attach(io: File.open("#{Rails.root.join('app/assets/images/badges/budges_ok.png')}"), filename: 'default.rb')
  end
end
