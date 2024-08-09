Drop Table #temp1


Select emp_id,  sum(sio_rate) As 'Total New Media Sales'
Into #temp1
From sio_table
inner join employees e1 On sio_emp_id = emp_id
inner join yearly_pubs On sio_yea_id = yea_id
inner join publications On yea_pub_id = pub_id
inner join emtype On emp_sale_type = emt_type
inner join cards On sio_car_id = car_id
Where  sio_date_cancelled is null and emp_sale_type in (41,102,37,13,33,3) and IsNull(emp_inactive,0) = 0 
and dbo.PublicationClassWorkLoad(pub_id) in ('Hospital Guide') and yea_year = 2024 and car_origin not in (10,9)
Group By  emp_id
Order by 1 


Select emt_type_desc Office, emp_first_name + ' ' + emp_last_name Salesperson, Sum(sio_rate) 'Total Sales',
isNULL([Total New Media Sales],0) 'New Sales Amount', Count(sio_id) 'Count of 2024 Hosp Sales' 
From sio_table s1
inner join employees e1 On sio_emp_id = emp_id
inner join yearly_pubs On sio_yea_id = yea_id
inner join publications On yea_pub_id = pub_id
inner join emtype On emp_sale_type = emt_type
left join #temp1 t1 On e1.emp_id = t1.emp_id
Where 1=1 and sio_date_cancelled is null and emp_sale_type in (41,102,37,13,33,3) and IsNull(emp_inactive,0) = 0 
and dbo.PublicationClassWorkLoad(pub_id) in ('Hospital Guide') and yea_year = 2024
Group by emt_type_desc, emp_first_name, emp_last_name, emp_sale_type,[Total New Media Sales]
Order By 1,2 asc;
/*
Select Distinct dbo.PublicationClassWorkLoad(pub_id)
From publications
Order by 1*/
