require 'spec_helper'

describe "StaticPages" do

  let(:base_title) { "Proof-of-Concept Web Application" }

  subject { page }

  describe "Home page" do
    before { visit root_path }

    it { should have_content('Welcome') }
    it { should have_title("#{base_title}") }
    it { should_not have_title('| Home') }
  end
  
  describe "Help page" do

    before { visit help_path }

    it { should have_content('Help') }
    it { should have_title("#{base_title} | Help") }
  end
  
  describe "About page" do
    before { visit about_path }
    it { should have_content('About Us') }
    it { should have_title("#{base_title} | About Us") }
  end

  describe "Contact page" do
    before { visit contact_path }
    it { should have_content('Contact') }
    it { should have_title("#{base_title} | Contact") }
  end
end
