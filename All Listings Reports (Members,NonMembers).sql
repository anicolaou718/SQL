--For Scott Brienberg's members/non members requests just show company name, cat(ask if he want), subcat(ask if he want), Member(Yes/No)
--spr_tasponsor_type is used to find preferred members You only have to ask chayim for approval for money amounts
-- Listings with a wsi_sio_id are paid listings and are a sale. When they ask for Upgrades, they mean AD Size

DECLARE @yea int
set @yea=31974833 

select pub_name +' '+yea_year+ ' Listings '+replace(convert(varchar(20),getdate(),110),'-','') from publications join yearly_pubs on yea_pub_id=pub_id where yea_id=@yea


Select Distinct--wsi_sio_id, 
wsi_company_name As 'Company',-- siz_ad_size As 'Ad Size',  
-- wsi_email Email,-- spr_email Email2, --(Select sio_rate from sio_table where sio_id = wsi_sio_id) As Amount,
--isNull(wsi_url,'') As 'URL', isNull(Convert(varchar,wsi_date_uploaded,101),'') As 'Date Uploaded', 
 wsi_address1 Address1, wsi_address2 Address2, wsi_city City, wsi_state 'State', wsi_zip Zip, wsi_phone Phone, --spr_phone, 
--wca_name As Category, wsc_name As SubCategory, 
spr_authorize_first_name + ' ' + spr_authorize_last_name Contact, spr_authorize_title Title,  (Case When isNull(spr_tamem,0) = 0 Then  'No' Else 'Yes' End) As Member--,
--,wsi_first_name, wsi_last_name, wsi_title
--,wsio_table.* --, 
--(Case When IsNULL(spr_tasponsor_type,0) = 0 Then  'No' Else 'Yes' End) As 'Preferred Member Logo', pub_name + ' '+ yea_year
From wsio_table -- wsiotable connects to most other tables similar to sio_table but it is used for websites/BGS
inner join sprospect On wsi_spr_id = spr_id -- important to see if company is a member
inner join sizes On wsi_siz_id = siz_id -- gets ad size
inner join wwscat_wsio On wws_wsi_id = wsi_id
inner join wscategory On wws_wsc_id = wsc_id
inner join wcategory On wsc_wca_id = wca_id
inner join wsection On wca_wse_id = wse_id
--inner join yearly_pubs On wsi_yea_id = yea_id
--inner join publications On yea_pub_id = pub_id
Where  wsi_yea_id = @yea 
and wsi_date_cancelled is Null and wse_date_cancelled is Null
and wsc_date_cancelled is Null and wca_date_cancelled is Null 
and wws_date_cancelled is null
--and isNull(spr_tamem,0) = 0
--and isNULL(wsi_sio_id,0) != 0 --ensures that this query finds paid listings only and not just free ads from members
Order By 1,2,3,4;
/*
Select *
from wsio_table*/



