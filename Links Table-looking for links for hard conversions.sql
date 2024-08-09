--When making hard conversion for two publications from different years for the same publication and company, check if two links are created.
-- check if the sou_source = conversion-hard and the lin_detail + lin_pyear matches where you made the hard conversion from. Plug in yea_id of pub you're making
--hard conversion for.
select	c1.car_note_link, reg_region, car_yea_id, car_location_type, lin_yea_id, lin_ins_id, spr_ins_id, car_id, lin_id, spr_id, car_origin,
car_created_by, car_created_on, pub_name + ' ' +  yea_year, lin_yea_id, pro_company_name,sou_source, lin_detail, lin_pyear--link_prospects_institutions.*
from	cards c1, yearly_pubs, publications, institutions_etc, region, sprospect, link_prospects_institutions, prospect, source
where	yea_id = c1.car_yea_id and pub_id = yea_pub_id and ins_id = pub_ins_id and reg_id = ins_reg_id and spr_id = c1.car_spr_id and spr_old_id = lin_spr_id and
spr_pro_id = pro_id and sou_id = lin_sou_id and lin_yea_id = car_yea_id
and		car_id = 942165009 --yea_id = 31971600 and car_origin = 71
order by car_created_on, pro_company_name

Select *
From link_prospects_institutions

select	lin_district, lin_comment, c1.car_note_link, reg_region, car_yea_id, car_location_type, lin_yea_id, lin_ins_id, spr_ins_id, car_id, lin_id, spr_id, car_origin,
car_created_by, car_created_on, lin_created_on, pub_name + ' ' +  yea_year, lin_yea_id, pro_company_name,sou_source, lin_detail, lin_pyear,lin_hc_id, link_prospects_institutions.*
--update link_prospects_institutions set lin_comment = replace(lin_comment, 'Sponsor of GA Airports Assoc 2022 Conference','') 
--update source set sou_source = replace(sou_source, 'georgiaairports.org','') 
from	cards c1
inner join yearly_pubs On yea_id = c1.car_yea_id 
inner join publications On pub_id = yea_pub_id
inner join institutions_etc On  ins_id = pub_ins_id 
inner join region On  reg_id = ins_reg_id
inner join sprospect On  spr_id = c1.car_spr_id
inner join link_prospects_institutions On lin_spr_id=spr_old_id and lin_yea_id=car_yea_id
inner join prospect On spr_pro_id = pro_id 
inner join source On sou_id = lin_sou_id 
where yea_id = 31976757 and lin_comment like '%Sponsor of GA Airports Assoc 2022 Conference%'  --and sou_source like '%georgiaairports.org%' --and lin_mod_by = 'anicolao' lin_comment like '%Listed in AAAE Vendor Directory%' --car_id = 942165009--yea_id = 940005439 --and lin_comment like '%Listed in AAAE Vendor Directory%'--car_id = 910049560 --pub_ins_id = 160003999 and car_origin not in (9,10,11,500,71) and sou_source like '%Board%Member%'
Order by 1
--begin tran
--commit


Select *
from source

Select * 
--delete
from link_prospects_institutions
where lin_yea_id = 940000074

