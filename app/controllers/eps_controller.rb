class EpsController < ApplicationController
  SELECT_TEST_SUITE = '-- Select test suite --'

  def upload_catalog
    @message = ''
    xls_file = params[:catalog_file]

    if xls_file.nil?
      render 'upload_catalog'
      return
    end

    file_path = 'automations/ep_automation/data'
    server_file_name = "AppCenterCatalog#{File.extname(xls_file.original_filename)}"
    upload = ModelCommon.upload_file(file_path, xls_file, server_file_name)

    if upload
      spreadsheet = ModelCommon.open_spreadsheet(File.join(file_path, server_file_name)).sheet(0).row(1)
      is_catalog = (spreadsheet & %w(skuCode seoURL seoTitle_en seoDescription_en)).count == 4 ? true : false
      if is_catalog
        @message = '<p class = "alert alert-success">The Catalog file is imported successfully!</p>'
      else
        @message = '<p class="alert alert-error">Please select correct Catalog file (.xls/.xlsx)</p>'
      end
    else
      @message = '<p class="alert alert-error">Please choose Catalog excel file to upload</p>'
    end
    render 'upload_catalog'
  end
end
