/*

if qri_gl=1 and updating start date then send the email below to Chayim and CJ.

if updating begin date you must update the following: 

invoice_Date = new start date

due date =  new start date

sio start date =  new start date

If updating end date you must update the following no need to ask to change just the end date:

sio end date =  new end date

DO NOT UPDATE THE PERIOD EVER
-----------------------------
if sale was billed:

CJ/Chayim,
Should the following sale below be cancelled and rewritten or ok to change the dates?  
The sales was billed.  If we make the change, It will not be automatically billed again and can only be billed again through @ Button.
------------------------------
if sale was not billed and start date is already passed:

CJ/Chayim,
Should the following sale below be cancelled and rewritten or ok to change the dates?  
The sales was not billed. If we make the change, It will be automatically billed tomorrow.
------------------------------
if sale was not billed and start date is in future:

CJ/Chayim,
Should the following sale below be cancelled and rewritten or ok to change the dates?  
The sales was not billed. If we make the change,  It will be automatically billed on the new start date.

-----------------------------

If CJ/Chayim say the ad should be cancelled Email Courtney per (CJ/Chayim) this should be cancelled/rewritten.

If updating dates send the following done email

Done. Run dates updated to the following below.

11/01/2022 - 12/31/2022

*/

--begin tran
--commit

--lesmanskeandsons@gmail.com

select sio_it_impressions,sio_sa_image,(case when isnull(sio_einv_sent,0)=0 then 'No' else 'Yes' end) as 'billed?',
sio_sa_impressions,siz_ad_size,sio_copy_category,qri_period,qri_gl,convert(varchar, qri_invoice_date, 101) as ari_invoice_date,
convert(varchar, qri_due_date, 101) as ari_due_date,convert(varchar, sio_sa_start, 101) as sio_sa_start ,convert(varchar, sio_sa_end, 101) as sio_sa_end,* 
--update sio_Table set sio_sa_start='2/1/24',sio_sa_end='2/29/24'
--update qrinvoice set qri_invoice_date='2/1/24', qri_due_date='2/1/24'
--update sprospect set spr_email=''
--update sio_table set sio_it_impressions=400000

from sio_Table
join sizes on siz_id=sio_siz_id

join qrinvoice on qri_sio_id=sio_id
join sprospect on spr_id=sio_spr_id

where sio_id in (390039154   )

--begin tran
--commit
--rollback