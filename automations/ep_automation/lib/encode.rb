class RspecEncode
  # This function is to encode some special chars to UTF-8
  # Created at: 12/31/2013
  def encode_title(text)
    # Trade Mark
    text = text.gsub("\u0099", "™")
    text = text.gsub("\u2122", "™")

    # ’
    text = text.gsub("\u0092", '"')

    # ’
    text = text.gsub("\u2019", '"')
    text = text.gsub("\u2026", "...")
    text = text.gsub("\u00A0", "")
  	text = text.gsub("\u00C0", "À")
  	text = text.gsub("\u00E9", "é")
    text = text.gsub("\u2044", "/")
  	text = text.gsub("\u00C9", "É")
  	text = text.gsub("&trade;", "™")
  	text = text.gsub("&middot;", "\u00B7")
    text
  end

  def encode_price(text)
    # €
    text.gsub("\u0080", "\u20AC")    
  end

  def process_longdesc(text)
    text = text.gsub("\r\n\r\n", " ")
    text = text.gsub(" \r\n", " ")
    text = text.gsub("\n", " ")
    text = text.gsub(" \n", " ")
    text = text.gsub("\r", "")
    text = text.gsub("\u00A0", " ")
    text = text.gsub(/["\u2019""\u2018"]/, '"')
    text = text.gsub("\u2013", "-")
    text = text.gsub("\u2014", "-")

    # Trade Mark
    text = text.gsub("\u0099", "™")
    text = text.gsub("\u2122", "™")

    # ’
    text = text.gsub("\u0092", '"')
    text = text.gsub("\u2026", "...")
    text = text.gsub("\u00A0", "")
    text = text.gsub("\u00C0", "À")
    text = text.gsub("\u00E9", "é")
    text = text.gsub("\u2044", "/")
    text = text.gsub("\u00C9", "É")
    text = text.gsub("N\u01D0 h\u01CEo", "Nǐ hǎo")
    text = text.gsub("N\u030Ci h\u030Cao", "Nǐ hǎo")

    # remove whitespace
    text = Capybara::Helpers.normalize_whitespace(text)
    text.strip
  end
end
