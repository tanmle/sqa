require 'spec_helper'

describe ImportExcelToMysqlController do

  describe "GET 'excel2mysql'" do
    it "returns http success" do
      get 'excel2mysql'
      response.should be_success
    end
  end

end
