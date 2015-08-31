class FetchPinAttributesController < ApplicationController
  skip_before_action :verify_authenticity_token
  def index
    flash.clear
  end

  def get_pins_status
    response_text = ''
    env = params[:pin_env]
    pins = params[:lf_pin]
    pin_management = PINManagement.new env

    if pins.to_s.length > 0
      arr_pin = pins.gsub(/\r/, '').split("\n")

      if arr_pin.count >= 0
        arr_pin.each do |pin|
          pin_san = pin.to_s.strip.gsub('-', '')

          if pin_san != ''
            status = pin_management.get_pin_status(pin_san)
            response_text = response_text + '<p>' << pin << ' = ' << "<span class='#{status.to_s.downcase}'>" << status << '</span>' << '</p>'
          end
        end
      end
    end
    render plain: response_text
  end
end
