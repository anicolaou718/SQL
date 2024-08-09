select Distinct pro_company_name Company, isNULL((select elo_description from elookup where elo_id = crm_company_type_id),'') 'Company Type', crm_id 
from sio_table
join cards on sio_car_id = car_id
join yearly_pubs on sio_yea_id = yea_id
join publications on yea_pub_id = pub_id
join sprospect b on sio_spr_id = b.spr_id
join prospect on b.spr_pro_id = pro_id
join employees on sio_emp_id = emp_id
left join crm on crm_pro_id = pro_old_id and crm_contact_first_name = b.spr_authorize_first_name and crm_contact_last_name = b.spr_authorize_last_name and sio_emp_id = crm_emp_id
where sio_date_cancelled is null and sio_emp_sale_type in (15,127,17)
and Year(sio_date_sold) = '2023'
order by 1,2
