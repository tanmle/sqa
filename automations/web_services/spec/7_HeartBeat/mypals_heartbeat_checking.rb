require File.expand_path('../../spec_helper', __FILE__)

=begin
MyPals Heartbeat checking: Verify all MayPals links work OK (response status is 200)
=end

endpoint_file = "#{Misc::CONST_PROJECT_PATH}/data/mypals_endpoint.txt"
endpoints = []

describe "MyPals HeartBeat Checking - #{Misc::CONST_ENV}" do
  file_obj = File.new(endpoint_file, 'r')
  while (line = file_obj.gets)
    url = line % LFSOAP::CONST_MYPALS_ENV
    res = LFCommon.get_http_code(url).to_s
    endpoints.push(url: url, res: res)
  end

  # Remember to close the file
  file_obj.close
  
  endpoints.each do |endpoint|
    context "URL #{endpoint[:url]}" do
      # Send request and check response status
      it "response: #{endpoint[:res]}" do
        expect(endpoint[:res]).to eq('200')
      end
    end
  end
end
