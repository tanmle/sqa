class Sqaauto222WsUseCommonActiveRecordModels < ActiveRecord::Migration
  def down
    remove_column :suites, :order
    remove_column :suite_maps, :order
    remove_column :case_suite_maps, :order
  end
  def up
    say 'schema changes'
    add_column :suites, :order, :integer
    add_column :suite_maps, :order, :integer
    add_column :case_suite_maps, :order, :integer

    say 'seed changes in sql - Sqaauto222WsUseCommonActiveRecordModels'

    say ' update order in \'suites\' table'
    (1..36).each { |n| update "update suites set `order` = #{n} where id = #{n}"}

    say ' update order in \'suite_maps\' table'
    (1..22).each { |n| update "update suite_maps set `order` = #{n + 1} where id = #{n}" }
    (23..30).each { |n| update "update suite_maps set `order` = #{n + 4} where id = #{n}" }

    say ' update order in \'case_suite_maps\' table'
    (1..147).each { |n| update "update case_suite_maps set `order` = #{n} where id = #{n}" }

    say ' suite ep content data'
    update "update suites set `order` = 1 where id = 41"
    update "update suites set `order` = 2 where id = 42"

    say '  case suite map ep content data'
    (201..218).each_with_index { |n, ix| update "update case_suite_maps set `order` = #{ix + 1} where case_id = #{n}" }
  end
end
