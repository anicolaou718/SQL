Drop Table #temp1

Select sio_id,
pro_company_name, pub_name + ' ' + yea_year Publications, spr_authorize_first_name + ' ' + spr_authorize_last_name Contact,
e1.emp_first_name + ' ' + e1.emp_last_name Employee, e1.emp_sale_type, e2.emp_first_name + ' ' + e2.emp_last_name CardOwner,
((Select isNull(Sum(qri_amount),0) from qrinvoice where qri_sio_id = sio_id ) -
(Select isNull(Sum(qrp_amount_applied),0)  from qrinvoice inner join qrpayment On qrp_qri_id = qri_id where qri_sio_id = sio_id ) ) As 'Amount Due',
(Select isNull(Sum(qrp_amount_applied),0)  from qrinvoice inner join qrpayment
On qrp_qri_id = qri_id where qri_sio_id = sio_id ) As 'Amount Paid', (Select isNull(Sum(qri_amount),0) from qrinvoice where qri_sio_id = sio_id )  'InvoiceAmt',
(Select isNull(Sum(qri_amount),0) from qrinvoice where qri_sio_id = sio_id ) -
(Select isNull(Sum(qrp_amount_applied),0)  from qrinvoice inner join qrpayment
On qrp_qri_id = qri_id where qri_sio_id = sio_id ) As Balance, e1.emp_inactive
Into #temp1
From sio_table 
inner join employees e1 On sio_emp_id = emp_id
inner join yearly_pubs On sio_yea_id = yea_id
inner join publications On yea_pub_id = pub_id
inner join sprospect On sio_spr_id = spr_id
inner join prospect On spr_pro_id = pro_id
inner join cards On sio_car_id = car_id
inner join aliases On ali_id = car_ali_id
inner join employees e2 On ali_emp_id = e2.emp_id
Where 1=1 
and sio_date_cancelled is null and sio_emp_sale_type = 17 and Year(sio_date_sold) = '2023' and isNull(e1.emp_inactive,0) = 0

Select pro_company_name Company, Publications, Contact, Employee, CardOwner, InvoiceAmt 'Amount of Sale', [Amount Paid] ,Balance
from #temp1
Where [Amount Due] > 0
Order by 4, 1

select	qri_sio_id, qri_date_void, sio_created_on, sio_date_sold,yea_date_printed, qri_invoice_date,qri_due_date,qri_sio_id, qri_ref_inv_num, qri_inv_num, qri_created_by, 
qri_created_on, qri_mod_by, qri_mod_on, qri_amount, qri_date_void,
pub_name + ' ' + yea_year, sio_ref_id, sio_rate, sio_date_cancelled, qri_pending_amount, qrinvoice.*
from	qrinvoice
inner join sio_table On sio_id = qri_sio_id
inner join yearly_pubs On sio_yea_id = yea_id
inner join publications On yea_pub_id = pub_id
where --qri_inv_num in (24024079,24002297,24012685,24002012)
qri_sio_id in (510005398,510006305,510006162,510007350)
Order by 1,2
