
drop table #tpspauth
drop table #tpspauth2

--Gets all PSP Package pubs with invoices
select distinct sio_id as sio,spr_authorize_first_name+' '+spr_authorize_last_name Authorizer, 
	sio_emp_id as sio_emp, pro_old_id as pro_old, pub_name, pro_company_name Company,
	emp_first_name + ' ' + emp_last_name Salesperson, sio_date_sold DateSold, sio_rate, yea_year
into #tpspauth
from sio_table
inner join yearly_pubs on sio_yea_id = yea_id
inner join publications on yea_pub_id = pub_id
inner join sprospect on sio_spr_id = spr_id
inner join prospect on spr_pro_id = pro_id
inner join institutions_etc On pub_ins_id = ins_id
inner join employees On sio_emp_id = emp_id 
where sio_date_cancelled is null
and ins_name like 'psp sports%'


--Gets all (non PSP package) pubs in the system that are a match on pro_old_id, Contact name and emp_id
select distinct sio_id, sio_created_on as sio_created,	sio_id as sio,spr_authorize_first_name+' '+spr_authorize_last_name Authorizer, sio_rate,
	sio_emp_id as sio_emp, pro_old_id as pro_old, pub_name + ' ' + yea_year pub, (Select isNull(Sum(ari_amount),0) from varinvoice where ari_sio_id = s1.sio_id ) -
(Select isNull(Sum(arp_amount_applied),0)  from varinvoice inner join varpayment
On arp_ari_id = ari_id where ari_sio_id = s1.sio_id ) As Balance, pro_company_name Company, emp_first_name + ' ' + emp_last_name Salesperson, sio_date_sold DateSold
into #tpspauth2
from sio_table s1
inner join yearly_pubs on sio_yea_id = yea_id
inner join publications on yea_pub_id = pub_id
inner join sprospect on sio_spr_id = spr_id
inner join prospect on spr_pro_id = pro_id
inner join employees On sio_emp_id = emp_id 
where sio_date_cancelled is null
and Cast(pro_old_id as varchar) +  spr_authorize_first_name+' '+spr_authorize_last_name + Cast(sio_emp_id as varchar) in
(Select Cast(pro_old_id as varchar) + Authorizer + Cast(sio_emp as varchar) From #tpspauth) and sio_id not in (Select sio from #tpspauth)

--Combines psp package pubs and corresponding non-psp package pubs w/ invoice values
Select distinct '::2212::'a,Company, Salesperson, DateSold,-- sio_rate
	Authorizer,	pub , (Select ari_ref_inv_num from varinvoice where ari_sio_id = sio) 'New Sale Inv #',-- 'Amount: ' + cast(sio_rate as varchar),
	   (Select isNull(Sum(ari_amount),0) from varinvoice where ari_sio_id = sio_id) As 'New Sale Invoice Amount',
(Select isNull(Sum(arp_amount_applied),0)  from varinvoice inner join varpayment On arp_ari_id = ari_id where ari_sio_id = sio_id ) As 'New Sale Payment' ,
	  sio_id, '----' a, 'y'
From #tpspauth2
inner join varinvoice va on ari_sio_id = sio_id
inner join varpayment  On arp_ari_id = va.ari_id
Where balance > 0 --and DateSold > DATEADD(year, -1, GetDate())
Group by Authorizer, pub, sio_id, Company, Salesperson, DateSold, sio --, sio_rate
union
Select distinct '::2212::'a, 'Company: ' + Company, 'Salesperson: ' + Salesperson, 'Date Sold: ' + Convert(varchar, DateSold, 101), 
	   'Contact: ' + Authorizer, 'Publication: ' + pub_name + ' ' yea_year, 'Invoice Number: ' + Cast((Select ari_ref_inv_num from varinvoice where ari_sio_id = sio) as varchar)'New Sale Inv #', 
	   'Amount: ' + cast(sio_rate as varchar),
	   'Invoice Amount: ' + Cast((Select isNull(Sum(ari_amount),0) from varinvoice where ari_sio_id = ari_sio_id) as varchar) As 'New Sale Invoice Amount',
'Payment Amount: ' + Cast((Select isNull(Sum(arp_amount_applied),0)  from varinvoice inner join varpayment On arp_ari_id = ari_id where ari_sio_id = sio ) as varchar)As 'New Sale Payment',
	  sio, '----' a, 'x'
From #tpspauth
--Where DateSold > DATEADD(year, -1, GetDate())
Group by Authorizer, pub_name, sio, Company, Salesperson, DateSold, sio_rate
Order by 2, 3, 5, 12, 6



--Combines psp package pubs and corresponding non-psp package pubs w/ invoice values
Select distinct '::2212::'a,Company, Salesperson, DateSold,-- sio_rate
	Authorizer,	pub ,  ari_ref_inv_num  'New Sale Inv #',
 (Select isNull(Sum(ari_amount),0)  from varinvoice where ari_sio_id = sio_id ) As 'Invoice Amount',
(Select isNull(Sum(arp_amount_applied),0)  from varinvoice inner join varpayment
On arp_ari_id = ari_id where ari_sio_id = sio_id ) As AmountPaid, sio_id, '----' a, 'y'
From #tpspauth2
left join varinvoice va on ari_sio_id = sio_id
Where balance > 0 
union
Select distinct '::2212::'a, Company, Salesperson, DateSold, 
	   Authorizer, pub_name, ari_ref_inv_num,
	   (Select isNull(Sum(ari_amount),0) from varinvoice where ari_sio_id = sio) As 'New Sale Invoice Amount',
(Select isNull(Sum(arp_amount_applied),0)  from varinvoice inner join varpayment On ari_sio_id = sio  where arp_ari_id = ari_id) As 'New Sale Payment',
	  sio , '----' a, 'x'
From #tpspauth
left join varinvoice va on ari_sio_id = sio
Group by Authorizer, pub_name, sio, Company, Salesperson, DateSold, ari_ref_inv_num
Order by 2, 3, 5, 12, 6



