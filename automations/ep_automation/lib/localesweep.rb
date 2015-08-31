class Title
  def calculateagestring(row)
		age_from = row['agefrommonths'].to_i/12
		age_to = row['agetomonths'].to_i/12
		age_string = "Ages: " + age_from.to_s + "-" + age_to.to_s
  end

  def calculateagestringforPDP(row)
    age_from = row['agefrommonths'].to_i/12
    age_to = row['agetomonths'].to_i/12
    age_string = "Ages " + age_from.to_s + "-" + age_to.to_s
  end

  def calculateagestring_fr(row)
    age_from = row['agefrommonths'].to_i/12
    age_to = row['agetomonths'].to_i/12
    age_string = "\u00C2ges: " + age_from.to_s + "-" + age_to.to_s
  end
  
  def calculateagestringforPDPFR(row)
    age_from = row['agefrommonths'].to_i/12
    age_to = row['agetomonths'].to_i/12
    age_string = "\u00C2ges " + age_from.to_s + "-" + age_to.to_s
  end  

	def calculateprice(row,pt)
    re_price = nil
		ptarray = row['pricetier'].strip.split(/ /, 3)
		pricetier = "#{ptarray[0]} #{ptarray[1]}"
		#pt1 = pt.dup		
		pt.data_seek(0)
				
		pt.each_hash do |row2|
			ptsub = row2['tier']
			if pricetier == ptsub
        re_price = row2['currencysymbol'] + row2['price']
			end
    end

    return 'Please check pricetier table' if re_price.nil?
    return re_price
	end
end
