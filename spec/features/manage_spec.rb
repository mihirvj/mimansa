require 'spec_helper'



feature "User account creation" do
      scenario "User creates a new account" do
    visit "/users/new"

    fill_in "first_name", :with => "abc"
    fill_in "last_name", :with=>  "Khurana"
    fill_in "email", :with=> "abc@gmail.com"
    fill_in "password", :with=>"people"
    click_button "Create Account"

      expect(page).to have_text("User was successfully created.")
  end
end
