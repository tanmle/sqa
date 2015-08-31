require File.expand_path('../../spec_helper', __FILE__)
require 'atg_app_center_cabo_french_page'

=begin
French ATG Cabo Content: Fill by Skill and check app information on Catalog page
=end

describe "French/CABO - Skills catalog checking - Env: #{Data::ENV_CONST} - Locale: #{Data::LOCALE_CONST.upcase}" do
  next unless app_exist?

  fr_cabo_atg_app_center_page = FrCaboAppCenterCatalogATG.new
  tc_num = 0

  skills_list = Connection.my_sql_connection(CaboAppCenterContent::CONST_CABO_QUERY_SKILL_CATALOG_DRIVE)
  skills_list.data_seek(0)
  skills_list.each_hash do |skill|
    skill_name = Title.map_french_to_english(skill['name'], 'skill')
    skill_href = skill['href']

    # Get all titles that belong to current locale and include skill_name
    titles = Connection.my_sql_connection(CaboAppCenterContent::CONST_CABO_QUERY_SKILL_CATALOG_TITLE % skill_name)
    titles_count = titles.count

    context "TC#{tc_num += 1}: Skill = '#{skill['name']}' - Total SKUs = #{titles_count}" do
      next unless app_available?(titles_count, "There are no apps available for Skill: #{skill_name}")

      product_html = {}
      before :all do
        fr_cabo_atg_app_center_page.load(CaboAppCenterContent::CONST_CABO_FILTER_URL % skill_href)
        product_html = fr_cabo_atg_app_center_page.generate_product_html
      end

      count = 0
      titles.data_seek(0)
      titles.each_hash do |title|
        e_product = fr_cabo_atg_app_center_page.get_expected_product_info_search_page title
        a_product = product_info = {}

        context "#{count += 1}. SKU = #{e_product[:sku]} - #{e_product[:short_name]}" do
          skip_flag = false

          before :each do
            skip ConstMessage::PRE_CONDITION_FAIL if product_info.empty? && skip_flag
          end

          it 'Find and get title information' do
            skip_flag = true
            product_info = fr_cabo_atg_app_center_page.get_product_info(product_html, e_product[:prod_number])

            fail "Title #{e_product[:sku]} is missing" if product_info.empty?

            skip_flag = false
            a_product = fr_cabo_atg_app_center_page.get_actual_product_info_search_page product_info
          end

          it "Verify Content/Type is '#{e_product[:content_type]}'" do
            expect(e_product[:content_type]).to include(a_product[:content_type])
          end

          it "Verify Long Name is '#{e_product[:long_name]}'" do
            expect(a_product[:long_name]).to eq(e_product[:long_name])
          end

          it "Verify Curriculum is '#{e_product[:curriculum]}'" do
            expect(a_product[:curriculum]).to eq(e_product[:curriculum])
          end

          it "Verify Age is '#{e_product[:age]}'" do
            expect(a_product[:age]).to eq(e_product[:age])
          end

          it "Verify Price is '#{e_product[:price]}'" do
            expect(a_product[:price]).to eq(e_product[:price])
          end
        end
      end
    end
  end
end
