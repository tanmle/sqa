require File.expand_path('../../spec_helper', __FILE__)

=begin
LeapTV Heartbeat checking: Verify all LeapTV links work well (response status is 200)
=end

endpoint_file = "#{Misc::CONST_PROJECT_PATH}/data/leaptv_endpoint.txt"
endpoints = []

describe "LeapTV HeartBeat Checking - #{Misc::CONST_ENV}" do
  file_obj = File.new(endpoint_file, 'r')
  while (line = file_obj.gets)
    url = line % GLASGOW::CONST_GLASGOW_ENV
    res = LFCommon.get_http_code(url.to_s)
    endpoints.push(url: url, res: res)
  end

  # remember to close the file
  file_obj.close

  endpoints.each do |endpoint|
    context "URL #{endpoint[:url]}" do
      it "response: #{endpoint[:res]}" do
        expect(endpoint[:res]).to eq('200')
      end
    end
  end
end
