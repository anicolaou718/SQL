Drop table #AllNotes
SELECT Distinct pro_company_name Company, e2.emp_first_name + ' ' + e2.emp_last_name CardOwner,e1.emp_first_name + ' ' + e1.emp_last_name C,
car_last_note,Not_notes ,Not_seq, SUBSTRING(not_notes, 15, 12) S, not_card_link, siz_ad_size As AD_Size,sio_rate As Amount, dbo.calculate_ma(sio_id) As MA, car_id, e2.emp_id, pub_name, yea_year
into #AllNotes
FROM sio_table 
inner join employees e1 On sio_emp_id = emp_id
inner join yearly_pubs On sio_yea_id = yea_id
inner join publications On yea_pub_id = pub_id
inner join sprospect On sio_spr_id = spr_id
inner join prospect On spr_pro_id = pro_id
inner join cards On sio_car_id = car_id
inner join aliases On car_ali_id = ali_id
inner join employees e2 On e2.emp_id = ali_emp_id
inner join notes On Not_card_link = car_note_link
inner join sizes On sio_siz_id = siz_id
WHERE sio_date_cancelled is null
AND sio_emp_sale_type = 87
and yea_year = 2023
--and car_yea_id != sio_yea_id and isNULL(pub_local,0) = 0
and pub_ins_id in (31950819) --160029642
--and not_notes like '%s]%' 
and not_notes like '%' + cast(e2.emp_id as varchar) +'%'
Order by 1,5,3




Select Distinct  Company, AD_Size, Amount, MA, 
C 'Original Salesperson', CardOwner,
Not_notes, not_card_link, car_id, emp_id, pub_name, yea_year
From (Select t.*,
row_number() over (partition by not_card_link order by not_seq desc) As seqnum from #AllNotes t ) t
where seqnum in (1)  --and (Invoice-Payment) > 0 Order By pro_old_id
Union
SELECT Distinct pro_company_name Company, siz_ad_size As AD_Size,sio_rate As Amount, dbo.calculate_ma(sio_id) As MA,
e1.emp_first_name + ' ' + e1.emp_last_name 'Original Salesperson', e2.emp_first_name + ' ' + e2.emp_last_name CardOwner,
'No Notes', not_card_link, car_id, e2.emp_id, pub_name, yea_year
FROM sio_table 
inner join employees e1 On sio_emp_id = emp_id
inner join yearly_pubs On sio_yea_id = yea_id
inner join publications On yea_pub_id = pub_id
inner join sprospect On sio_spr_id = spr_id
inner join prospect On spr_pro_id = pro_id
inner join cards On sio_car_id = car_id
inner join aliases On car_ali_id = ali_id
inner join employees e2 On e2.emp_id = ali_emp_id
inner join notes On Not_card_link = car_note_link
inner join sizes On sio_siz_id = siz_id
WHERE sio_date_cancelled is null
AND sio_emp_sale_type = 87
and yea_year = 2023
--and car_yea_id != sio_yea_id and isNULL(pub_local,0) = 0
and pub_ins_id in (31950819) --
--and not_notes like '%s]%' 
and car_id not in (Select car_id From #AllNotes)
Order by 1,5,3