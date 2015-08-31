class EpSoapImportingsController < ApplicationController
  def index
    session[:hid_selected_language] = 'english'
  end

  def soap2db
    import
    session[:hid_selected_language] = params[:language]
    render 'index'
  end

  #
  # import data from soap call to db
  # 1. delete all data
  # 2. call service and then update to db
  #
  def import
    import_soap_to_db = ImportSoapToDb.new
    # begin transaction
    begin
      connection = Connection.new
      connection.open_connection_in_config
      connection.con.autocommit false

      # Call service and then update to db
      if params[:language] == 'english'
        # DELETE ALL RECORDS
        connection.execute_sql_statement 'delete from ep_temp'
        import_soap_to_db.import_data_for_english(connection.con, 'ep_temp')
      elsif params[:language] == 'french'
        connection.execute_sql_statement 'delete from ep_temp_fr'
        import_soap_to_db.import_data_for_french(connection.con, 'ep_temp_fr')
      end

      connection.con.commit # commit transaction
      @message = "<p class='alert alert-success'>Successfully import! Please kindly recheck imported data</p>"
    rescue Exception => e
      connection.con.rollback # rollback transaction
      @message = 'PLEASE SELECT CORRECT TABLE. <br/><br/>' << e.message
    ensure
      connection.close_connection if connection

    end # end begin transaction
  end
end
