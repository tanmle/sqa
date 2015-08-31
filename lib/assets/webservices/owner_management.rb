class OwnerManagement
  attr_accessor :wsdl
  CONST_CALLER_ID = ENV['CONST_CALLER_ID']

  def initialize(env = 'QA')
    @wsdl = CommonMethods.get_wsdl ENV['CONST_OWNER__MGT'], env
  end

  def claim_device(session, _customer_id, device_serial, platform, slot, profile_name, child_id, dob = Time.now, grade = '5', gender='male')
    CommonMethods.soap_call(
      @wsdl,
      :claim_device,
      "<caller-id>#{CONST_CALLER_ID}</caller-id>
      <session type='service'>#{session}</session>
      <device serial='#{device_serial}' auto-create='false' product-id='0' platform='#{platform}' pin=''>
        <profile slot='#{slot}' name='#{profile_name}' weak-id='1' uploadable='true' claimed='true' child-id='#{child_id}' dob='#{dob}' grade='#{grade}' gender='#{gender}' auto-create='false' points='0' rewards='0'/>
      </device>"
    )
  end
end
