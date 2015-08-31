$env = nil
$session = nil
class AccountsController < ApplicationController
  PLATFORMS_CONST = { 'Jump' => 'leapband', 'LeapTV' => 'leapup', 'LeapPad3' => 'leappad3explorer', 'LeapPad Ultra' => 'leappad3', 'LeapPad2' => 'leappad2', 'LeapPad1' => 'leappad', 'Leapster Explorer' => 'leapster2', 'LeapsterGS Explorer' => 'explorer2', 'LeapReader' => 'leapreader', 'Bogota' => 'leappadplatinum', 'Narnia' => 'android1' }

  def clear_account
    unless params[:account]
      @account = Account.new
      return
    end

    env = params[:env]
    authentication = Authentication.new env
    device_management = DeviceManagement.new env
    customer_management = CustomerManagement.new env
    license_management = LicenseManagement.new env

    @account = Account.new(account_params)
    email = params[:account][:email]
    password = params[:account][:password]
    device = ''

    if @account.save
      # Begin process deleting all device link to account
      # Authenticate & get session token
      session = authentication.get_service_session(email, password)
      return @account.errors.set(:fail, ['to authenticate your email, password.']) if session[0] == 'error'

      # If 'Remove license only' checkbox is un-checked -> Clear devices, Else-> Do not clear account
      if params[:remove_license_only] == '1'
        device = 'Remove license only'
      else
        devices = device_management.list_nonimate_devices_info session
        devices.each do |el|
          serial = el[:serial]
          platform = el[:platform]
          if device_management.unnominate_device(session, serial) == true
            device = device << platform << ': ' << serial << ','
          end
        end
      end

      # Begin process deleting license link to account
      # get customer id by username
      customer_id = customer_management.get_customer_id(email)

      # fetchRestrictedLicenses
      fetch_restricted_licenses_res = license_management.fetch_restricted_licenses(session, customer_id)

      # revokeLicense for each license
      license = license_management.get_revoked_license(fetch_restricted_licenses_res, session)
      # End process deleting license link to account

      # return data to show
      @account.email = email
      @account.password = password
      @account.device = device
      @account.license = license

      # update data to database
      @account.update(email: email, password: password, device: device, license: license)
      render 'show'
      return
    end

    render 'clear_account'
  end

  def link_devices
    @all_platforms = PLATFORMS_CONST.to_a.unshift(['All', 'all'])
  end

  def process_linking_devices
    account = Account.new
    auto_link = params[:atg_ld_autolink]
    env = params[:atg_ld_env]
    email = params[:atg_ld_email]
    password = params[:atg_ld_password]
    platform = params[:atg_ld_platform]

    if auto_link == 'true'
      if platform == 'all'
        PLATFORMS_CONST.each_value do |v|
          account.do_oobe_flow(env, true, email, password, v)
        end
      else
        account.do_oobe_flow(env, true, email, password, platform)
      end
    else
      child_id = params[:atg_ld_children]
      device_serial = params[:atg_ld_deviceserial]
      account.do_oobe_flow(env, false, email, password, platform, child_id, device_serial)
    end

    render plain: ['success']
  end

  def show
    @account = Account.find params[:id]
  end

  def fetch_customer
    # Previous condition: get necessary information from parameters
    @env = $env = params[:env]
    @editable = false
    customer_management = CustomerManagement.new $env
    authentication = Authentication.new $env
    child_management = ChildrenManagement.new $env
    device_management = DeviceManagement.new $env
    license_management = LicenseManagement.new $env
    package_management = PackageManagement.new $env

    # error message if email is not proper
    email = params[:user_email].nil? ? nil : valid_email(params[:user_email])

    if email.nil?
      render 'fetch_customer'
      return
    end

    password = params[:user_password].to_s
    if password.empty?
      case params[:env]
      when 'QA'
        $session = ENV['CONST_SESSION_QA']
      when 'STAGING'
        $session = ENV['CONST_SESSION_STAGING']
      else # 'PROD'
        $session = ENV['CONST_SESSION_PROD']
      end
    else
      $session = authentication.get_service_session(email, password)
      if $session[0] == 'error'
        flash.now[:error] = $session[1]
        render 'fetch_customer'
        return false
      else
        @editable = true
        flash.clear
      end
    end

    # 1. get Customer ID from email
    customer_id = customer_management.get_customer_id email
    if customer_id[0] == 'error' || customer_id.blank?
      flash.now[:error] = 'The email address or password you entered is incorrect. Please try again.'
      render 'fetch_customer'
    else
      # 2. fetch Customer info
      res = customer_management.fetch_customer customer_id
      @cus_info = Hash.from_xml(res.at_xpath('//customer').to_s)

      unless params[:user_password].blank?
        # 3. listChildren from ChildManagementService with params: session, cus-id
        @children = child_management.list_children_info $session, customer_id

        # 4. listNominatedDevices from DeviceManagementService with params: session
        @devices = device_management.list_nonimate_devices_info $session

        # 5. Get app license information on Account
        account_license = license_management.get_all_account_licenses($session, customer_id)

        # Get app_name by on SKU number
        account_license.each do |license|
          license[:app_name] = package_management.get_package_name(license[:sku])
        end

        # 6. Get app license information on Device
        device_arr = package_management.get_device_licenses($session, @devices)
        device_license = filter_device_license(device_arr)

        # Map the app information on device and account
        @apps = get_license_info(account_license, device_license)

        # 7. Get the list of available license on Account
        @revoke_license = []
        account_license.each do |acc|
          @revoke_license.push([acc[:app_name], acc[:license_id]])
        end
      end

      # Display account information into index page
      render 'fetch_customer'
    end
  end

  def update_customer
    customer_management = CustomerManagement.new $env
    @email = params[:email]
    @firstname = params[:first_name]
    @lastname = params[:last_name]
    @middle = params[:middle_name]
    @alias = params[:alias]
    @screen = params[:screen]
    @locale = params[:locale]
    @salutation = params[:salutation]
    @cusid = params[:cus_id]
    @username = params[:username]
    @password = params[:password]
    @password_hint = params[:password_hint]
    @phone_msg = ''
    @addr_msg = ''

    if params[:num_of_addr].nil?
      @addr_msg = (<<-INTERPOLATED_HEREDOC.strip_heredoc
        <address type=\'#{params[:address_type]}\' id=\'#{params[:addr_id]}\'>
          <street>#{params[:street]}</street>
          <region city=\'#{params[:city]}\' country=\'#{params[:country]}\' province=\'#{params[:province]}\' postal-code=\'#{params[:postal]}\'/>
        </address>
      INTERPOLATED_HEREDOC
      ) if !params[:address_type].nil? || !params[:addr_id].nil? || !params[:street].nil?
    else
      @num_of_addr = params[:num_of_addr].to_i
      (1..@num_of_addr).each do |i|
        @addr_msg << <<-INTERPOLATED_HEREDOC.strip_heredoc
          <address type=\'#{params[:"address_type#{i}"]}\' id=\'#{params[:"addr_id#{i}"]}\'>
            <street>#{params[:"street#{i}"]}</street>
              <region city=\'#{params[:"city#{i}"]}\' country=\'#{params[:"country#{i}"]}\' province=\'#{params[:"province#{i}"]}\' postal-code=\'#{params[:"postal#{i}"]}\'/>
          </address>
        INTERPOLATED_HEREDOC
      end
    end

    if params[:num_of_phones].nil?
      @phone_msg = (<<-INTERPOLATED_HEREDOC.strip_heredoc
        <phone type=\'#{params[:phone_type]}\' extension=\'#{params[:ext]}\' number=\'#{params[:number]}\'/>
      INTERPOLATED_HEREDOC
      ) if !params[:phone_type].nil? || !params[:ext].nil? || !params[:number].nil?

    else
      @num_of_phones = params[:num_of_phones].to_i
      (1..@num_of_phones).each do |i|
        @phone_msg << <<-INTERPOLATED_HEREDOC.strip_heredoc
          <phone type=\'#{params[:"phone_type#{i}"]}\' extension=\'#{params[:"ext#{i}"]}\' number=\'#{params[:"number#{i}"]}\'/>
        INTERPOLATED_HEREDOC
      end
    end

    # update customer
    customer_management.update_customer_full_info(@cusid, @firstname, @lastname, @middle, @salutation, @locale, @alias, @screen, @email, @phone_msg, @addr_msg, @username, @password, @password_hint)

    flash.clear
    flash.now[:success] = 'Account is updated successfully!'
    render 'fetch_customer'
  end

  def revoke_license
    flash.clear
    license_management = LicenseManagement.new $env
    license_id = params[:revoke_license]

    revoke = license_management.revoke_license($session, license_id)
    if revoke == true
      flash.now[:success] = 'App license is revoked successfully'
    else
      flash.now[:error] = revoke[1]
    end

    render 'fetch_customer'
  end

  def remove_license
    package_management = PackageManagement.new $env
    remove = package_management.remove_installation($session, params[:device_serial], params[:sku], params[:slot])

    if remove[0] == 'error'
      flash.now[:error] = remove[1]
    else
      flash.now[:success] = 'App is removed successfully'
    end

    render 'fetch_customer'
  end

  #
  # Install package license into device
  #
  def report_installation
    package_management = PackageManagement.new $env
    install = package_management.report_installation($session, params[:device_serial], params[:sku], params[:license_id])
    if install[0] == 'error'
      flash.now[:error] = install[1]
    else
      flash.now[:success] = 'App is installed successfully'
    end

    render 'fetch_customer'
  end

  private

  def account_params
    params.require(:account).permit(:email, :password, :device, :license, :env)
  end

  def valid_email(email)
    return email if email =~ /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    flash.now[:error] = 'The email\'s format should be: example@abc.com'
    nil
  end

  #
  # This method is used to map the app information on device and account
  # Include info: license_id, app_title, sku, type, grant_date, device_serial, status, slot, package_id
  #
  def get_license_info(account_license, device_license)
    account_license.map do |acc|
      {
        license_id: acc[:license_id],
        app_name: acc[:app_name],
        sku: acc[:sku],
        type: acc[:type],
        grant_date: acc[:grant_date],
        device_info: device_license.select { |license| license[:package_name] == acc[:app_name] }
      }
    end
  end

  #
  # Get status, package_name of app on device
  # If app is installed on device -> get slot that app installed
  #
  def filter_device_license(arr)
    temp = []
    (0..arr.length - 1).each do |i|
      (i + 1..arr.length - 1).each do |j|
        if arr[i][:device_serial] == arr[j][:device_serial] && arr[i][:package_name] == arr[j][:package_name]
          if arr[i][:status] == 'pending'
            arr[i][:status] = arr[j][:status]
            arr[i][:slot] = arr[j][:slot]
            temp.push(arr[j]) # duplicate items into 'temp' array
            break
          elsif arr[j][:status] == 'pending'
            arr[j][:status] = arr[i][:status]
            arr[j][:slot] = arr[i][:slot]
            temp.push(arr[i])
            break
          end
          next
        end
        next
      end
    end
    arr - temp # Remove duplicated items
  end
end
