require 'spec_helper'

describe "Authentication" do

  subject { page }

  describe "signin page" do
    before { visit signin_path }

    it { should have_content('Fetch User') }
    it { should have_title('Fetch User') }
  end
end
