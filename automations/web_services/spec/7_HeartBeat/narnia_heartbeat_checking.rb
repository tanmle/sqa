require File.expand_path('../../spec_helper', __FILE__)

=begin
Narnia Heartbeat checking: Verify WS endpoints is alive (response status is 400 or 405)
=end

endpoint_file = "#{Misc::CONST_PROJECT_PATH}/data/narnia_endpoints.txt"
endpoints = []

describe "Narnia HeartBeat Checking - #{Misc::CONST_ENV}" do
  file_obj = File.new(endpoint_file, 'r')
  while (line = file_obj.gets)
    url = line % LFSOAP::CONST_NARNIA_ENV
    res = LFCommon.get_http_code(url).to_s
    endpoints.push(url: url, res: res)
  end

  # Remember to close the file
  file_obj.close

  endpoints.each do |endpoint|
    context "URL #{endpoint[:url]}" do
      if endpoint[:res] == '400'
        it "response: #{endpoint[:res]}" do
          expect(endpoint[:res]).to eq('400')
        end
      else
        it "response: #{endpoint[:res]}" do
          expect(endpoint[:res]).to eq('405')
        end
      end
    end
  end
end
