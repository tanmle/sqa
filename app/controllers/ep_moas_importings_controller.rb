class EpMoasImportingsController < ApplicationController
  def index
    session[:hid_selected_language] = nil
  end

  # form method
  # import MOAS excel file to database
  def excel2mysql
    moas_file = params[:excel_file]
    catalog_file = params[:catalog_excel_file]
    ymal_file = params[:excel_ymal_file]
    table = params[:language] == 'english' ? 'ep_titles' : 'ep_titles_fr'

    # initial EpMoasImporting model
    ep_moas_importing = EpMoasImporting.new(table, params[:language])

    # get temporary path of uploaded files
    path = Rails.root.join('public', 'upload')

    # delete files
    FileUtilsC.delete_files(path)

    # upload file
    moas_file_name = moas_file.blank? ? false : ModelCommon.upload_file(path, moas_file)
    catalog_file_name = catalog_file.blank? ? false : ModelCommon.upload_file(path, catalog_file)
    ymal_file_name = ymal_file.blank? ? false : ModelCommon.upload_file(path, ymal_file)

    # import to mysql
    if !(moas_file_name || catalog_file_name || ymal_file_name)
      @message = '<p class="alert alert-error">Please select correct .xls/.xlsx file</p>'
    else
      @message = ep_moas_importing.import(File.join(path, moas_file_name))
      if @message == '<p class = "alert alert-success">MOAS file is imported successfully!</p>'
        @message << ep_moas_importing.update_catalog_to_moas(File.join(path, catalog_file_name)) unless catalog_file.nil?
        @message << ep_moas_importing.update_ymal_to_moas(File.join(path, ymal_file_name)) unless ymal_file.nil?
      end
    end

    session[:hid_selected_language] = params[:language]
    render 'index'
  end
end
