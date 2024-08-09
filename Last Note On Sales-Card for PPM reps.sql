Drop table #AllNotes
SELECT Distinct pro_company_name Company, e2.emp_first_name + ' ' + e2.emp_last_name CardOwner,e1.emp_first_name + ' ' + e1.emp_last_name Salesperson, car_last_note,Not_notes ,Not_seq,-- SUBSTRING(not_notes, 15, 12) S,
not_card_link
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
WHERE sio_date_cancelled is null
AND sio_emp_sale_type = 87
and yea_year = 2023
and car_yea_id != sio_yea_id and isNULL(pub_local,0) = 0
and pub_ins_id in (4534,90000013, 5106,4999)
and not_notes like '%s]%'
Order by 1,5,3


Select Distinct *
From (Select t.*,
row_number() over (partition by not_card_link order by not_seq desc) As seqnum from #AllNotes t ) t
where seqnum in (1)  Order by 1 asc --and (Invoice-Payment) > 0 Order By pro_old_id
