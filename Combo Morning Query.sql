Select  sio_ref_id, sio_rate_make_contract,sum(sio_rate) As sum
From sio_table
Where sio_ref_id is not null and sio_date_cancelled is not null and sio_created_on >= '07/24/23' and sio_rate_make_contract is null
Group By sio_rate_make_contract, sio_id, sio_ref_id
Having sum(sio_rate) >= 99500
Order By sio_ref_id

Drop Table #tempcombo

Select sio_ref_id, sum(sio_rate) As Amount
Into #tempcombo
From sio_table
Where  sio_date_cancelled is null and sio_ref_id is not null  and sio_created_on >= '07/25/23' and 
sio_ref_id in (Select sio_ref_id from sio_table where sio_rate_make_contract is null and sio_date_cancelled is null and sio_ref_id is not null and sio_created_on >= '07/25/23')
Group By sio_ref_id
Having sum(sio_rate) >= 99500
Order By sio_ref_id


Select sio_id, sio_ref_id, sio_rate, sio_rate_make_contract, sio_created_on
From sio_table
Where sio_ref_id in (Select sio_ref_id From #tempcombo) and sio_date_cancelled is null

Select sio_ref_id, sio_rate_make_contract, sio_date_cancelled, sio_created_on,sio_rate,  *
From sio_table
Where sio_rate_make_contract is null and sio_ref_id is not null and sio_date_cancelled is null and sio_created_on >= '07/25/23'