require File.expand_path('../../spec_helper', __FILE__)

require 'mysql'
require 'capybara/rspec'
require 'rspec/expectations'
require 'rspec'
require 'const'
require 'encode'
require 'htmlentities'
coder = HTMLEntities.new
encode = RspecEncode.new

# Initiate variables are fields that will be verified
golivedate = nil
# appstatus = nil
sku = nil
shorttitle = nil
longtitle = nil
gender = nil
agefrommonths = nil
agetomonths = nil
skill = nil
curriculum = nil
longdesc = nil
# credits = nil
platformcompatibility = nil
# specialmsg = nil
teaches = nil
# licenselegal = nil
# licnonlic = nil
# license = nil
# language = nil
pricetier = nil
category = nil
us = nil
ca = nil
uk = nil
ie = nil
au = nil
row = nil
fr_fr = nil
fr_ca = nil
fr_row = nil
lpu = nil
lp2 = nil
lp1 = nil
lgs = nil
lex = nil
lpr = nil

# Initiate connection
con = Mysql.new MySQLConst::CONST_SERVER, MySQLConst::CONST_USERNAME, MySQLConst::CONST_PASSOWRD, MySQLConst::CONST_DATABASE, MySQLConst::CONST_PORT

# Process data before checking
con.query "UPDATE ep_titles SET us = '' where us is NULL"
con.query "UPDATE ep_titles SET ca = '' where ca is NULL"
con.query "UPDATE ep_titles SET uk = '' where uk is NULL"
con.query "UPDATE ep_titles SET ie = '' where ie is NULL"
con.query "UPDATE ep_titles SET au = '' where au is NULL"
con.query "UPDATE ep_titles SET row = '' where row is NULL"
con.query "UPDATE ep_titles SET fr_row = '' where fr_row is NULL"
con.query "UPDATE ep_titles SET fr_fr = '' where fr_fr is NULL"
con.query "UPDATE ep_titles SET fr_ca = '' where fr_ca is NULL"

# ================== Begin checking Titles that only appear on temp =====================
feature '= Titles that only appear on temp table'  do
  rstemp = con.query 'select * from ep_temp'

  # Initiate variable to count rows that only appear on temp table
  countrow = 0

  rstemp.each_hash do |rowtemp|
    # Get record that contains the same sku from ep_titles table
    rstitles = con.query "select * from ep_titles where sku='#{rowtemp['sku']}'"

    if rstitles.num_rows == 0
      scenario "=> #{rowtemp['sku']} - \"#{rowtemp['shorttitle']}\""
      countrow += 1
    end
  end # end row.each

  scenario "=> There are #{rstemp.num_rows} titles on temp table" do
    puts rstemp.num_rows
  end
  scenario "=> There are #{countrow} titles that only appear on temp table" do
    puts countrow
  end

end # end feature
# ================== End checking Titles that only appear on temp =====================

# ================== Begin cheking Titles that only appear on titles =====================
feature '= Titles that only appear on titles table'  do
  rstitles = con.query 'select * from ep_titles'

  # Initiate variable to count rows that only appear on titles table
  countrow = 0

  rstitles.each_hash do |rowtitles|
    # Get record that contains the same sku in temp table
    rstemp = con.query "select * from ep_temp where sku='#{rowtitles['sku']}'"

    if rstemp.num_rows == 0
      scenario "=> #{rowtitles['sku']} - \"#{rowtitles['shorttitle']}\""
      countrow += 1
    end
  end # end row.each

  scenario "=> There are #{rstitles.num_rows} titles on titles table" do
    puts rstitles.num_rows
  end
  scenario "=> There are #{countrow} titles that only appear on titles table" do
    puts countrow
  end

end # end feature
# ================== Titles that only appear on titles =====================

# ================== Begin compare data between titles table and temp table ============
feature '== Compare titles between titles table (from MOAS file) and temp table (from SOAP call response)'  do
  rstitles = con.query 'select * from ep_titles'

  # Starting getting output data
  rstitles.each_hash do |rowtitles|
    context "=== Testing SKU = #{rowtitles['sku']} - #{rowtitles['shorttitle']}" do
      # Get record that contains sku in titles
      rstemp = con.query "select * from ep_temp where sku='#{rowtitles['sku']}'"

      if rstemp.num_rows != 0
        # assert sku in page
        scenario 'Checking sku in page' do
          rstemp.each_hash do |rowtemp|
            golivedate = rowtemp['golivedate']
            # appstatus = rowtemp['appstatus']
            sku = rowtemp['sku']
            shorttitle = rowtemp['shorttitle']
            longtitle = rowtemp['longtitle']
            gender = rowtemp['gender']
            agefrommonths = rowtemp['agefrommonths']
            agetomonths = rowtemp['agetomonths']
            skill = rowtemp['skill']
            curriculum = rowtemp['curriculum']
            longdesc = rowtemp['longdesc']
            # credits = rowtemp['credits']
            platformcompatibility = rowtemp['platformcompatibility']
            # specialmsg = rowtemp['specialmsg']
            teaches = rowtemp['teaches']
            # licenselegal = rowtemp['licenselegal']
            # licnonlic = rowtemp['licnonlic']
            # license = rowtemp['license']
            # language = rowtemp['language']
            pricetier = rowtemp['pricetier']
            category = rowtemp['category']
            us = rowtemp['us']
            ca = rowtemp['ca']
            uk = rowtemp['uk']
            ie = rowtemp['ie']
            au = rowtemp['au']
            row = rowtemp['row']
            fr_fr = rowtemp['fr_fr']
            fr_ca = rowtemp['fr_ca']
            fr_row = rowtemp['fr_row']
            lpu = rowtemp['lpu']
            lp2 = rowtemp['lp2']
            lp1 = rowtemp['lp1']
            lgs = rowtemp['lgs']
            lex = rowtemp['lex']
            lpr = rowtemp['lpr']
          end
          expect(sku).to eq(rowtitles['sku'])
        end

        # assert golivedate
        scenario "Checking golivedate \"#{rowtitles['golivedate']}\"" do
          expect(golivedate).to eq(rowtitles['golivedate'])
        end

        # assert shorttitle
        scenario "Checking title \"#{rowtitles['shorttitle']}\"" do
          expect(shorttitle).to eq(rowtitles['shorttitle'])
        end

        # assert longtitle
        scenario "Checking longtitle \"#{rowtitles['shorttitle']}\"" do
          expect(shorttitle).to eq(rowtitles['shorttitle'])
        end

        # assert gender
        scenario "Checking gender \"#{rowtitles['gender']}\"" do
          expect(gender).to eq(rowtitles['gender'])
        end

        # assert agefrommonths
        scenario "Checking agefrommonths \"#{rowtitles['agefrommonths']}\"" do
          expect(agefrommonths).to eq(rowtitles['agefrommonths'])
        end

        # assert agetomonths
        scenario "Checking agetomonths \"#{rowtitles['agetomonths']}\"" do
          expect(agetomonths).to eq(rowtitles['agetomonths'])
        end

        # assert skill
        scenario "Checking skill \"#{rowtitles['skill']}\"" do
          expect(skill).to eq(rowtitles['skill'])
        end

        # assert curriculum
        scenario "Checking curriculum \"#{rowtitles['curriculum']}\"" do
          expect(curriculum).to eq(rowtitles['curriculum'])
        end

        # assert longdesc
        scenario "Checking longdesc \"#{rowtitles['longdesc']}\"" do
          expect(coder.decode(longdesc)).to eq(encode.process_longdesc(rowtitles['longdesc']))
        end

        # assert credits
        # scenario "Checking credits \"#{rowtitles['credits']}\"" do
        # expect(credits).to eq(rowtitles['credits'])
        # end

        # assert platformcompatibility
        # scenario "Checking platformcompatibility \"#{rowtitles['platformcompatibility']}\"" do
        # expect(coder.decode(platformcompatibility)).to eq(rowtitles['platformcompatibility'])
        # end

        # #assert specialmsg
        # scenario "Checking specialmsg \"#{rowtitles['specialmsg']}\"" do
        # expect(coder.decode(specialmsg)).to eq(rowtitles['specialmsg'].gsub("\r\n","<br />"))
        # end

        # assert teaches
        scenario "Checking teaches \"#{rowtitles['teaches']}\"" do
          expect(teaches).to eq(rowtitles['teaches'].gsub("\n", ''))
        end

        # assert pricetier
        scenario "Checking pricetier \"#{rowtitles['pricetier']}\"" do
          expect(pricetier).to include(rowtitles['pricetier'])
        end

        # assert category
        scenario "Checking category \"#{rowtitles['category']}\"" do
          expect(category).to eq(rowtitles['category'])
        end

        # assert locale us
        scenario "Checking locale us \"#{rowtitles['us']}\"" do
          expect(us).to eq(rowtitles['us'])
        end

        # assert locale ca
        scenario "Checking locale ca \"#{rowtitles['ca']}\"" do
          expect(ca).to eq(rowtitles['ca'])
        end

        # assert locale uk
        scenario "Checking locale uk \"#{rowtitles['uk']}\"" do
          expect(uk).to eq(rowtitles['uk'])
        end

        # assert locale ie
        scenario "Checking locale ie \"#{rowtitles['ie']}\"" do
          expect(ie).to eq(rowtitles['ie'])
        end

        # assert locale au
        scenario "Checking locale au \"#{rowtitles['au']}\"" do
          expect(au).to eq(rowtitles['au'])
        end

        # assert locale row
        scenario "Checking locale us \"#{rowtitles['row']}\"" do
          expect(row).to eq(rowtitles['row'])
        end

        # assert locale fr_fr
        scenario "Checking locale fr_fr \"#{rowtitles['fr_fr']}\"" do
          expect(fr_fr).to eq(rowtitles['fr_fr'])
        end

        # assert locale fr_ca
        scenario "Checking locale fr_ca \"#{rowtitles['fr_ca']}\"" do
          expect(fr_ca).to eq(rowtitles['fr_ca'])
        end

        # assert locale fr_row
        scenario "Checking locale fr_row \"#{rowtitles['fr_row']}\"" do
          expect(fr_row).to eq(rowtitles['fr_row'])
        end

        # assert storefront lpu
        scenario "Checking storefront lpu \"#{rowtitles['lpu']}\"" do
          expect(lpu).to eq(rowtitles['lpu'])
        end

        # assert storefront lp2
        scenario "Checking storefront lp2 \"#{rowtitles['lp2']}\"" do
          expect(lp2).to eq(rowtitles['lp2'])
        end

        # assert storefront lp1
        scenario "Checking storefront lp1 \"#{rowtitles['lp1']}\"" do
          expect(lp1).to eq(rowtitles['lp1'])
        end

        # assert storefront lgs
        scenario "Checking storefront lgs \"#{rowtitles['lgs']}\"" do
          expect(lgs).to eq(rowtitles['lgs'])
        end

        # assert storefront lex
        scenario "Checking storefront lex \"#{rowtitles['lex']}\"" do
          expect(lex).to eq(rowtitles['lex'])
        end

        # assert storefront lpr
        scenario "Checking storefront lpr \"#{rowtitles['lpr']}\"" do
          expect(lpr).to eq(rowtitles['lpr'])
        end
      end # end if
    end # end context
  end # end row.each

end # end feature

# close connection
con.close
