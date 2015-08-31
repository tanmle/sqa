require File.expand_path('../../spec_helper', __FILE__)

=begin
INMON Heartbeat checking: Verify all INMON links work well (response status is 200)
=end

endpoint_file = "#{Misc::CONST_PROJECT_PATH}/data/webservice_endpoint.txt"
endpoints = []

describe "Webservice INMON HeartBeat checking - #{Misc::CONST_ENV}" do
  file_obj = File.new(endpoint_file, 'r')
  while (line = file_obj.gets)
    url = "#{LFSOAP::CONST_URL}#{line.chomp}"
    res = LFCommon.get_http_code(url).to_s
    endpoints.push(url: url, res: res)
  end
  file_obj.close # remember to close the file

  endpoints.each do |endpoint|
    context "URL #{endpoint[:url]}" do
      # Send request and check response status
      it "response: #{endpoint[:res]}" do
        expect(endpoint[:res]).to eq('200')
      end
    end
  end
end
