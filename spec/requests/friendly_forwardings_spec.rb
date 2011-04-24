require 'spec_helper'

describe "FriendlyForwardings" do
  it "should forward to the requested page after signin" do
    user = Factory(:user)
    visit edit_user_path(user)
    fill_in :email, :with => user.email
    fill_in :password, :with => user.password
    click_button
    response.should render_template('users/edit')
    # remember that in an integration test, the machine will follow the redirect;
    # hence, you must use "RENDER_TEMPLATE"
  end
end
