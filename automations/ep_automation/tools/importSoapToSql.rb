ruby_lib = ENV['RUBYLIB']
load_path = ENV['LOAD_PATH']
$LOAD_PATH.unshift(load_path,ruby_lib)
require 'mysql'
require 'xml_helper'
require 'const'
require 'nokogiri'

begin
  # Initiate connection to database
  con = Mysql.new MySQLConst::CONST_SERVER, MySQLConst::CONST_USERNAME, MySQLConst::CONST_PASSOWRD, MySQLConst::CONST_DATABASE, MySQLConst::CONST_PORT
  
  # Get all node in xml file that contains product information
  temp = XMLHelper.new('./0-100.xml').getNodeValues('*//Products/Product')
  item_index_update = 0
  item_index_insert = 0
  
  # Prepair data for fields that will add to database
  temp.each do |item|
    $catalog = item.at_xpath('Catalog').text
    if item.xpath('Price/Currency').text == 'USD'
      $price = '$' + '%0.2f' % item.xpath('Price/PriceTier/ListPrice').text.to_f
    else
      $price = ''
    end
    $appstatus = "unknown"
    $sku = item.at_xpath('SkuCode').text
    $shorttitle = item.at_xpath('Name').text
    $platformcompatibility = ''
    $lpu = ''
    $lp2 = ''
    $lp1 = ''
    $lgs = ''
    $lex = ''
    $lpr = ''
    # --Process locale
    $us = ''
    $ca = ''
    $uk = ''
    $ie = ''
    $au = ''
    $row = ''
    $fr_fr = ''
    $fr_ca = ''
    $fr_row = ''
    if $catalog.include? 'US_'
      $us = 'X'
    end
    if $catalog.include? 'UK_'
      $uk = 'X'
    end
    if $catalog.include? 'IE_'
      $ie = 'X'
    end
    if $catalog.include? 'AU_'
      $au = 'X'
    end
    if $catalog.include? 'ROW_'
      $row = 'X'
    end
    if $catalog.include? 'FR_FR_'
      $fr_fr = 'X'
    end
    if $catalog.include? 'FR_CA_'
      $fr_ca = 'X'
    else
      if $catalog.include? 'CA_'
        $ca = 'X'
    end
    end
    if $catalog.include? 'FR_ROW_'
      $fr_row = 'X'
    end  
    # --End Process locale
    
    item.at_xpath('Attributes').elements.to_a.each do |i| # begin each child
      case i.attributes['Key'].text
        
      # Go live date maps with release date in database
      when "releaseDate"
        $golivedate = i.at_xpath('Values').text
      
      # long name maps with longtitle in database
      when "longName_en", "longName_fr"
        $longtitle = i.at_xpath('Values').text
      
      # Gender maps with gender in database
      when "gender_en", "gender_fr"
        genderflag = 0
        i.elements.to_a.each do |m|
          if m.name=='Values'
            $gender = m.text.capitalize
            genderflag += 1
        end
        if genderflag == 2
          $gender = 'All'
        end
        
      end        
      
      # Age Range Begin maps with agefrommonths in database
      when "ageRangeBegin"
        $agefrommonths = i.at_xpath('Values').text 
      
      # Age Range End maps with agefrommonths in database
      when "ageRangeEnd"
        $agetomonths = i.at_xpath('Values').text   
      
      # Skill maps with skill in database
      when "skill_en", "skill_fr"
        $skill = i.at_xpath('Values').text     
      
      # curriculum maps with curriculum in database
      when "curriculum_en", "curriculum_fr"
        $curriculum = i.at_xpath('Values').text
      
      # Long Description maps with longdesc in database
      when "longDescription_en", "longDescription_fr"
        $longdesc = i.at_xpath('Values').text.gsub("\"", "\\\"")
      
      # credits will map later
      $credits = 'unknown'     
      
      #---------platformcompatibility process
      # worksWithLeapPad2_en maps with platformcompatibility in database
      when "worksWithLeapPad2_en", "worksWithLeapPad2_fr"
        if i.at_xpath('Values').text == "true"
          $platformcompatibility += "LeapPad 2,\n"
          $lp2 = 'X'
        end  
      # worksWithLeapPad_en maps with platformcompatibility in database
      when "worksWithLeapPad_en", "worksWithLeapPad_fr"
        if i.at_xpath('Values').text == "true"
          $platformcompatibility += "LeapPad Explorer,\n"
          $lp1 = 'X'
        end
      # worksWithLeapPadUltra_en maps with platformcompatibility in database
      when "worksWithLeapPadUltra_en", "worksWithLeapPadUltra_fr"
        if i.at_xpath('Values').text == "true"
          $platformcompatibility += "LeapPad Ultra,\n"
          $lpu = 'X'
        end
      # worksWithLeapster_en maps with platformcompatibility in database
      when "worksWithLeapster_en", "worksWithLeapster_fr"
        if i.at_xpath('Values').text == "true"
          $platformcompatibility += "Leapster Explorer,\n"
          $lex = 'X'
        end
      # worksWithLeapsterGS_en maps with platformcompatibility in database
      when "worksWithLeapsterGS_en", "worksWithLeapsterGS_fr"
        if i.at_xpath('Values').text == "true"
          $platformcompatibility += "LeapsterGS Explorer,\n"
          $lgs = 'X'
        end
      # worksWithLeapReader_en maps with platformcompatibility in database
      when "worksWithLeapReader_en", "worksWithLeapReader_fr"
        if i.at_xpath('Values').text == "true"
          $platformcompatibility += "Leapreader,\n"
          $lpr = 'X'
        end 
      #---------End platformcompatibility process   
      
      # Special Message maps with speacialmsg in database
      when "specialMessage_en", "specialMessage_fr" 
        if i.at_xpath('Values') != nil
          $specialmsg = i.at_xpath('Values').text 
        end
      
      # Teaches maps with teaches in database
      when "teaches_en", "teaches_fr"
        $teaches = i.at_xpath('Values').text           
      
      # License legal will be added later
      $licenselegal = 'unknown' 
      
      # licensedContent will be added later
      $licnonlic = 'unknown' 
      
      # License will be added later
      $license = "unknown"
      
      # language will be added later
      $language = "unknown"
      
      # Pricetier maps with pricetier"
      when "pricingTier"
        $pricetier = i.at_xpath('Values').text + ' - ' +  $price
      
      # contentType maps with category
      when "contentType"
        $category = i.at_xpath('Values').text   
      end # end case
    end # end each child  
    
    # Excute query to add data to database    
    # -- Begin Process if sku has ready existed
    rowsku = con.query "SELECT sku,us,ca,uk,ie,au,row,fr_fr,fr_ca,fr_row from #{TableName::CONST_TABLE_NAME}"
    skuexisted = 0
    rowsku.each_hash do |rs|
      if $sku == rs['sku']
        if rs['us'].downcase == 'x'
          $us = 'X'
        end
        if rs['ca'].downcase == 'x'
          $ca = 'X'
        end
        if rs['uk'].downcase == 'x'
          $uk = 'X'
        end
        if rs['ie'].downcase == 'x'
          $ie = 'X'
        end
        if rs['au'].downcase == 'x'
          $au = 'X'
        end
        if rs['row'].downcase == 'x'
          $row = 'X'
        end
        if rs['fr_fr'].downcase == 'x'
          $fr_fr = 'X'
        end
        if rs['fr_ca'].downcase == 'x'
          $fr_ca = 'X'
        end
        if rs['fr_row'].downcase == 'x'
          $fr_row = 'X'
        end
        
        skuexisted = 1
        
        break
      end # end if 
    end # end each
    # -- End Process if sku has ready existed
    if skuexisted == 1
      item_index_update = item_index_update + 1
      puts "****update: #{item_index_update}************************************"
      puts "UPDATE #{TableName::CONST_TABLE_NAME}
      SET golivedate = '#{$golivedate}', appstatus = '#{$appstatus}', shorttitle = \"#{$shorttitle}\", longtitle = \"#{$longtitle}\", gender = '#{$gender}', agefrommonths = '#{$agefrommonths}', agetomonths = '#{$agetomonths}', skill = '#{$skill}', curriculum = \"#{$curriculum}\", longdesc = \"#{$longdesc}\", credits = '#{$credits}', platformcompatibility = '#{$platformcompatibility}', specialmsg = \"#{$specialmsg}\",teaches = \"#{$teaches}\",licenselegal = '#{$licenselegal}', licnonlic = '#{$licnonlic}', license = '#{$license}', language = '#{$language}', pricetier = '#{$pricetier}', category = '#{$category}', us = '#{$us}', ca = '#{$ca}', uk = '#{$uk}', ie = '#{$ie}', au = '#{$au}', row = '#{$row}', fr_fr = '#{$fr_fr}', fr_ca = '#{$fr_ca}', fr_row = '#{$fr_row}', lpu = '#{$lpu}', lp2 = '#{$lpu}', lp1 = '#{$lp1}', lgs = '#{$lgs}', lex = '#{$lex}', lpr = '#{$lpr}'
      WHERE sku = '#{$sku}';"
      
      if $pricetier.include? '$'
        con.query "UPDATE #{TableName::CONST_TABLE_NAME}
                   SET golivedate = '#{$golivedate}', appstatus = '#{$appstatus}', shorttitle = \"#{$shorttitle}\", longtitle = \"#{$longtitle}\", gender = '#{$gender}', agefrommonths = '#{$agefrommonths}', agetomonths = '#{$agetomonths}', skill = '#{$skill}', curriculum = \"#{$curriculum}\", longdesc = \"#{$longdesc}\", credits = '#{$credits}', platformcompatibility = '#{$platformcompatibility}', specialmsg = \"#{$specialmsg}\",teaches = \"#{$teaches}\",licenselegal = '#{$licenselegal}', licnonlic = '#{$licnonlic}', license = '#{$license}', language = '#{$language}', pricetier = '#{$pricetier}', category = '#{$category}', us = '#{$us}', ca = '#{$ca}', uk = '#{$uk}', ie = '#{$ie}', au = '#{$au}', row = '#{$row}', fr_fr = '#{$fr_fr}', fr_ca = '#{$fr_ca}', fr_row = '#{$fr_row}', lpu = '#{$lpu}', lp2 = '#{$lpu}', lp1 = '#{$lp1}', lgs = '#{$lgs}', lex = '#{$lex}', lpr = '#{$lpr}'
                   WHERE sku = '#{$sku}';" 
      else
        con.query "UPDATE #{TableName::CONST_TABLE_NAME}
                   SET golivedate = '#{$golivedate}', appstatus = '#{$appstatus}', shorttitle = \"#{$shorttitle}\", longtitle = \"#{$longtitle}\", gender = '#{$gender}', agefrommonths = '#{$agefrommonths}', agetomonths = '#{$agetomonths}', skill = '#{$skill}', curriculum = \"#{$curriculum}\", longdesc = \"#{$longdesc}\", credits = '#{$credits}', platformcompatibility = '#{$platformcompatibility}', specialmsg = \"#{$specialmsg}\",teaches = \"#{$teaches}\",licenselegal = '#{$licenselegal}', licnonlic = '#{$licnonlic}', license = '#{$license}', language = '#{$language}', category = '#{$category}', us = '#{$us}', ca = '#{$ca}', uk = '#{$uk}', ie = '#{$ie}', au = '#{$au}', row = '#{$row}', fr_fr = '#{$fr_fr}', fr_ca = '#{$fr_ca}', fr_row = '#{$fr_row}', lpu = '#{$lpu}', lp2 = '#{$lpu}', lp1 = '#{$lp1}', lgs = '#{$lgs}', lex = '#{$lex}', lpr = '#{$lpr}'
                   WHERE sku = '#{$sku}';" 
       end
    else
      item_index_insert = item_index_insert + 1
      puts "****insert: #{item_index_insert}************************************"
      puts "INSERT INTO #{TableName::CONST_TABLE_NAME} (golivedate,appstatus,sku,shorttitle,longtitle,gender,agefrommonths,agetomonths,skill,curriculum,longdesc,credits,platformcompatibility,specialmsg,teaches,licenselegal,licnonlic,license,language,pricetier,category,us,ca,uk,ie,au,row,fr_fr,fr_ca,fr_row,lpu,lp2,lp1,lgs,lex,lpr)
      VALUES ('#{$golivedate}','#{$appstatus}','#{$sku}',\"#{$shorttitle}\",\"#{$longtitle}\",'#{$gender}','#{$agefrommonths}','#{$agetomonths}','#{$skill}',\"#{$curriculum}\",\"#{$longdesc}\",'#{$credits}','#{$platformcompatibility}',\"#{$specialmsg}\",\"#{$teaches}\",'#{$licenselegal}','#{$licnonlic}',
      '#{$license}','#{$language}','#{$pricetier}','#{$category}','#{$us}','#{$ca}','#{$uk}','#{$ie}','#{$au}','#{$row}','#{$fr_fr}','#{$fr_ca}','#{$fr_row}','#{$lpu}','#{$lp2}','#{$lp1}','#{$lgs}','#{$lex}','#{$lpr}');"
      
      con.query "INSERT INTO #{TableName::CONST_TABLE_NAME} (golivedate,appstatus,sku,shorttitle,longtitle,gender,agefrommonths,agetomonths,skill,curriculum,longdesc,credits,platformcompatibility,specialmsg,teaches,licenselegal,licnonlic,license,language,pricetier,category,us,ca,uk,ie,au,row,fr_fr,fr_ca,fr_row,lpu,lp2,lp1,lgs,lex,lpr)
                VALUES ('#{$golivedate}','#{$appstatus}','#{$sku}',\"#{$shorttitle}\",\"#{$longtitle}\",'#{$gender}','#{$agefrommonths}','#{$agetomonths}','#{$skill}',\"#{$curriculum}\",\"#{$longdesc}\",'#{$credits}','#{$platformcompatibility}',\"#{$specialmsg}\",\"#{$teaches}\",'#{$licenselegal}','#{$licnonlic}',
                '#{$license}','#{$language}','#{$pricetier}','#{$category}','#{$us}','#{$ca}','#{$uk}','#{$ie}','#{$au}','#{$row}','#{$fr_fr}','#{$fr_ca}','#{$fr_row}','#{$lpu}','#{$lp2}','#{$lp1}','#{$lgs}','#{$lex}','#{$lpr}');"
    end
  end # enc each parent
  
  # Close connection after finishing query
  con.close
  
  puts "\nTotal updated items: #{item_index_update}"
  puts "Total inserted items: #{item_index_insert}"
  puts "******Finish!**********".upcase()
  
rescue Exception => msg 
    puts "error: #{msg}"
    if !con.nil?
      con.close
    end 
end
