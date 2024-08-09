Select Distinct yea_year 'Year', pro_company_name Company, sio_date_sold DateSold, sio_rate Amount, dbo.calculate_ma(sio_id) MA, dbo.NetSales(sio_id) NetSales,
sio_sa_impressions Impressions, emp_first_name + ' ' + emp_last_name Salesperson, spr_authorize_first_name + ' ' + spr_authorize_last_name Contact,
sio_sa_start StartDate,sio_sa_end EndDate, pub_name, yea_year
From sio_table 
inner join employees e1 On sio_emp_id = emp_id
inner join yearly_pubs On sio_yea_id = yea_id
inner join publications On yea_pub_id = pub_id
inner join sprospect On sio_spr_id = spr_id
inner join prospect On spr_pro_id = pro_id
inner join institutions_etc On pub_ins_id = ins_id
inner join Region On ins_reg_id = reg_id 
inner join sizes On sio_siz_id = siz_id
inner join cards On sio_car_id = car_id
inner join aliases On car_ali_id = ali_id
Where pub_ins_id = 31960429 and yea_year in (2022, 2023,2024)
and sio_date_cancelled is null
Order by 1,2,3,10