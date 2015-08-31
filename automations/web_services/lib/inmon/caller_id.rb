class CallerID
  def self.generate_id(caller_id, title, version, build)
    LFCommon.soap_call(
      LFWSDL::CONST_CALLER_ID,
      :generate_id,
      "<caller-id>#{caller_id}</caller-id>
      <application title='#{title}' version='#{version}' build='#{build}'>
        <cal:caller-id xmlns:cal='http://services.leapfrog.com/inmon/callerid/'/>
      </application>"
    )
  end

  def self.lookup_id(caller_id, query)
    LFCommon.soap_call(
      LFWSDL::CONST_CALLER_ID,
      :lookup_id,
      "<caller-id>#{caller_id}</caller-id>
      <query>#{query}</query>"
    )
  end
end
