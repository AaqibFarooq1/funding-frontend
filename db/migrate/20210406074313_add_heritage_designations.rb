class AddHeritageDesignations < ActiveRecord::Migration[6.1]
  def up
    execute "insert into heritage_designations (designation, created_at, updated_at) values ('accredited_museum_gallery_or_archive', now(), now());"
    execute "insert into heritage_designations (designation, created_at, updated_at) values ('designated_or_significant_collection', now(), now());"
    execute "insert into heritage_designations (designation, created_at, updated_at) values ('dcms_funded_museum_gallery_or_archive', now(), now());"
    execute "insert into heritage_designations (designation, created_at, updated_at) values ('world_heritage_site', now(), now());"
    execute "insert into heritage_designations (designation, created_at, updated_at) values ('grade_1_or_a_listed_building', now(), now());"
    execute "insert into heritage_designations (designation, created_at, updated_at) values ('grade_2_star_or_b_listed_building', now(), now());"
    execute "insert into heritage_designations (designation, created_at, updated_at) values ('grade_2_c_or_cs_listed_building', now(), now());"
    execute "insert into heritage_designations (designation, created_at, updated_at) values ('local_list', now(), now());"
    execute "insert into heritage_designations (designation, created_at, updated_at) values ('scheduled_ancient_monument', now(), now());"
    execute "insert into heritage_designations (designation, created_at, updated_at) values ('registered_historic_ship', now(), now());"
    execute "insert into heritage_designations (designation, created_at, updated_at) values ('conservation_area', now(), now());"
    execute "insert into heritage_designations (designation, created_at, updated_at) values ('registered_battlefield', now(), now());"
    execute "insert into heritage_designations (designation, created_at, updated_at) values ('anob_or_nsa', now(), now());"
    execute "insert into heritage_designations (designation, created_at, updated_at) values ('national_park', now(), now());"
    execute "insert into heritage_designations (designation, created_at, updated_at) values ('national_nature_reserve', now(), now());"
    execute "insert into heritage_designations (designation, created_at, updated_at) values ('ramsar_site', now(), now());"
    execute "insert into heritage_designations (designation, created_at, updated_at) values ('rigs', now(), now());"
    execute "insert into heritage_designations (designation, created_at, updated_at) values ('sac', now(), now());"
    execute "insert into heritage_designations (designation, created_at, updated_at) values ('spa', now(), now());"
    execute "insert into heritage_designations (designation, created_at, updated_at) values ('grade_1_listed_park_or_garden', now(), now());"
    execute "insert into heritage_designations (designation, created_at, updated_at) values ('grade_2_star_listed_park_or_garden', now(), now());"
    execute "insert into heritage_designations (designation, created_at, updated_at) values ('grade_2_listed_park_or_garden', now(), now());"
    execute "insert into heritage_designations (designation, created_at, updated_at) values ('protected_wreck_site', now(), now());"
    execute "insert into heritage_designations (designation, created_at, updated_at) values ('national_historic_organ_register', now(), now());"
    execute "insert into heritage_designations (designation, created_at, updated_at) values ('site_of_special_scientific_interest', now(), now());"
    execute "insert into heritage_designations (designation, created_at, updated_at) values ('local_nature_reserve', now(), now());"
    execute "insert into heritage_designations (designation, created_at, updated_at) values ('other', now(), now());"
  end

  def down
    execute "delete from heritage_designations where designation = 'accredited_museum_gallery_or_archive';"
    execute "delete from heritage_designations where designation = 'designated_or_significant_collection';"
    execute "delete from heritage_designations where designation = 'dcms_funded_museum_gallery_or_archive';"
    execute "delete from heritage_designations where designation = 'world_heritage_site';"
    execute "delete from heritage_designations where designation = 'grade_1_or_a_listed_building';"
    execute "delete from heritage_designations where designation = 'grade_2_star_or_b_listed_building';"
    execute "delete from heritage_designations where designation = 'grade_2_c_or_cs_listed_building';"
    execute "delete from heritage_designations where designation = 'local_list';"
    execute "delete from heritage_designations where designation = 'scheduled_ancient_monument';"
    execute "delete from heritage_designations where designation = 'registered_historic_ship';"
    execute "delete from heritage_designations where designation = 'conservation_area';"
    execute "delete from heritage_designations where designation = 'registered_battlefield';"
    execute "delete from heritage_designations where designation = 'anob_or_nsa';"
    execute "delete from heritage_designations where designation = 'national_park';"
    execute "delete from heritage_designations where designation = 'national_nature_reserve';"
    execute "delete from heritage_designations where designation = 'ramsar_site';"
    execute "delete from heritage_designations where designation = 'rigs';"
    execute "delete from heritage_designations where designation = 'sac';"
    execute "delete from heritage_designations where designation = 'spa';"
    execute "delete from heritage_designations where designation = 'grade_1_listed_park_or_garden';"
    execute "delete from heritage_designations where designation = 'grade_2_star_listed_park_or_garden';"
    execute "delete from heritage_designations where designation = 'grade_2_listed_park_or_garden';"
    execute "delete from heritage_designations where designation = 'protected_wreck_site';"
    execute "delete from heritage_designations where designation = 'national_historic_organ_register';"
    execute "delete from heritage_designations where designation = 'site_of_special_scientific_interest';"
    execute "delete from heritage_designations where designation = 'local_nature_reserve';"
    execute "delete from heritage_designations where designation = 'other';"
  end
end