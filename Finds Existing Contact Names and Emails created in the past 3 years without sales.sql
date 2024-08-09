--Change yea_id and/or date **Only Region yea_ids ** if email doesn't include area code use the below query WITHOUT Area Codes
/*
DECLARE @yea int
set @yea=93000520

DECLARE @datee datetime
set @datee= '01/10/2024'--DateADD(month, -6 ,getdate()) --DateADD(month, -6 ,(DateADD(day, -2 ,getdate())))

DECLARE @AR varchar(100);
SET @AR = ''; -- Don't need to input anything here


--Change AreaCodes in Query and then run!!

Drop Table #tempAreaCode
Create Table #tempAreaCode(
AreaCode varchar(3))

Insert Into #tempAreaCode
Select '727' Union Select '813' Union Select '656' /*Union Select '952' Union Select '703' Union Select '571' */


--Finds Existing Contact Names and Emails for companies the past 3 years from date in email w/o cards that have had sales on them WITH AREA CODES
 -- **Only Region yea_ids**
--Make sure to change the DATE and YEAID!!!!	
--Please see attached for a list of contacts created in the past three years starting from 04/03/2023 in the Seattle Region with the area code 206 without any sales

SELECT @AR += AreaCode + ','
FROM #tempAreaCode;

--File Name
select pub_name + ' Contacts Created in the Past 3 Yrs from ' + replace(convert(varchar(20),@datee,110),'-','') +
' without any Sales ' + replace(convert(varchar(20),getdate(),110),'-','') As ExcelFileName
from publications join yearly_pubs on yea_pub_id=pub_id where yea_id=@yea

--Email Response
select 'Please see attached for a list of contacts created in the past three years starting from ' +
replace(convert(varchar(20),@datee,110),'-','') + ' in the '+ pub_name +
' with the area codes '+ LEFT(@AR,LEN(@AR)-1) +' excluding contacts where the company was previously sold. ' As EmailResponse
from publications join yearly_pubs on yea_pub_id=pub_id where yea_id=@yea

-- Area Code query
Select Distinct pro_company_name As Company, 
isNull(spr_authorize_first_name,'') As 'Contact First Name',
isNULL(spr_authorize_last_name,'') As 'Contact Last Name', 
isNull(spr_authorize_title,'') As 'Contact Title', isNULL(spr_phone,'') As 'Phone',
isNULL(spr_phone2,'') As Phone2, isNULL(spr_cellular,'') As Cellular,
spr_email As Email, pub_name -- Don't Include pub_name
From cards 
inner join sprospect sp1 On car_spr_id = spr_id
inner join prospect p1 On spr_pro_id = pro_id
inner join yearly_pubs On car_yea_id = yea_id
inner join publications On yea_pub_id = pub_id
Where yea_id in (@yea) --Make Sure to Change Region Yea_id 
and spr_created_on >= DateAdd(year, -3, @datee) and spr_created_on <= @datee -- Make sure to change the dates 
and isNull(spr_email,'') != '' and 
not exists
(Select * From sio_table inner join sprospect sp2 On sio_spr_id = spr_id
inner join prospect p2 On spr_pro_id = pro_id
Where p1.pro_old_id = p2.pro_old_id --and sp1.spr_authorize_first_name = sp2.spr_authorize_first_name 
--and sp1.spr_authorize_last_name = sp2.spr_authorize_last_name 
and sio_date_cancelled is null) 
and Exists (Select * From #tempAreaCode where SUBSTRING(Replace(sp1.spr_phone, '+',''), 1, 3) = AreaCode or SUBSTRING(Replace(sp1.spr_phone2, '+',''), 1, 3) = AreaCode
or SUBSTRING(Replace(sp1.spr_cellular, '+', ''), 1, 3) = AreaCode)
Order by 1,2;

/*
--Checks area codes in table
Select *
From #tempAreaCode
*/
*/
/*
/*
Below Query: Doesn't use Area Code

--Finds Existing Contact Names and Emails for companies the past 3 years from date in email w/o cards that have had sales on them WITHOUT AREA CODES 
--Make sure to change the DATE and YEAID!!!! **Only Region yea_ids**
-- Run query below for contacts without area codes clause
*/

DECLARE @yea int
set @yea=31953659

DECLARE @datee datetime
set @datee= '01/01/2024'

--File Name
select pub_name + ' Contacts Created in the Past 3 Yrs from ' + replace(convert(varchar(20),@datee,110),'-','') +
' without any Sales ' + replace(convert(varchar(20),getdate(),110),'-','')
from publications join yearly_pubs on yea_pub_id=pub_id where yea_id=@yea

--Email Response
select 'Please see attached for a list of contacts created in the past three years starting from ' +
replace(convert(varchar(20),@datee,110),'-','') + ' in the '+ pub_name +
' excluding contacts where the company was previously sold. ' As EmailResponse
from publications join yearly_pubs on yea_pub_id=pub_id where yea_id=@yea


-- Non-Area Code using query
Select Distinct pro_company_name As Company, isNull(spr_authorize_first_name,'') As 'Contact First Name',
isNULL(spr_authorize_last_name,'') As 'Contact Last Name', 
isNull(spr_authorize_title,'') As 'Contact Title',
isNULL(spr_phone,'') As 'Phone', isNULL(spr_phone2,'') As Phone2, isNULL(spr_cellular,'') As Cellular,
spr_email As Email, pub_name--, spr_state, year(spr_created_on)
From cards 
inner join sprospect sp1 On car_spr_id = spr_id
inner join prospect p1 On spr_pro_id = pro_id
inner join yearly_pubs On car_yea_id = yea_id
inner join publications On yea_pub_id = pub_id
Where yea_id in (@yea) --Make Sure to Change Region Yea_id 
and spr_created_on >= DateAdd(year, -3, @datee) and spr_created_on <= @datee -- Make sure to change the dates 
--and Year(spr_created_on) in (2022,2023) 
and isNull(spr_email,'') != '' and
not exists
(Select * From sio_table inner join sprospect sp2 On sio_spr_id = spr_id
inner join prospect p2 On spr_pro_id = pro_id
Where p1.pro_old_id = p2.pro_old_id --and sp1.spr_authorize_first_name = sp2.spr_authorize_first_name 
--and sp1.spr_authorize_last_name = sp2.spr_authorize_last_name 
and sio_date_cancelled is null) 
Order by 1,2;

*/



/*
Below Query: Doesn't use Area Code- SVP EMAIL BLASTS
--Make sure to change the YEARS, STATE and PUBINSID!!!! **Only SVP yea_ids**

*/

--CHANGE INS ID
DECLARE @ins int
set @ins=31953659

--CHANGE STATE
DECLARE @state varchar(3)
set @state = 'VA'

--CHANGE Sales Year
DECLARE @YR varchar(4)
set @YR = '2024'

--Change Contact YEARS in Query BASED ON PAIGE's EMAIL and then run!!
declare @YEARS table (years int, counts int );
Insert Into @YEARS(years,counts) values ('2022', 1), ('2023',2), ('2024', 3)



declare @start int = 1
declare @end int = (Select count(years) from @YEARS)
declare @output varchar(60) = ''

WHILE @start <= @end
 BEGIN
SET @Output = @Output + (SELECT cast(years as varchar) FROM @YEARS WHERE counts = @start) + ', '
SET @start = @start + 1
END




/*Email Format:*/

--File Name
select ins_name + ' Contacts Created in ' + @Output +'without any Sales in ' + @YR 
from institutions_etc where ins_id=@ins

--Email Response
select 'Please see attached for a list of ' + @state +' contacts created in ' + @Output +
'in the '+ ins_name + ' excluding contacts where the company was previously sold in ' + @YR As EmailResponse
from institutions_etc where ins_id=@ins


-- SVP Email Blast Query
Select Distinct pro_company_name As Company, isNull(spr_authorize_first_name,'') As 'Contact First Name',
isNULL(spr_authorize_last_name,'') As 'Contact Last Name', 
isNull(spr_authorize_title,'') As 'Contact Title',
isNULL(spr_phone,'') As 'Phone', isNULL(spr_phone2,'') As Phone2, isNULL(spr_cellular,'') As Cellular,
spr_email As Email, pub_name--, spr_state, year(spr_created_on)
From cards 
inner join sprospect sp1 On car_spr_id = spr_id
inner join prospect p1 On spr_pro_id = pro_id
inner join yearly_pubs On car_yea_id = yea_id
inner join publications On yea_pub_id = pub_id
Where pub_ins_id in (@ins)
and year(spr_created_on) in (Select years From @YEARS ) 
and isNull(spr_email,'') != '' and spr_state = @state and
not exists
(Select * From sio_table inner join sprospect sp2 On sio_spr_id = spr_id
inner join prospect p2 On spr_pro_id = pro_id
Where p1.pro_old_id = p2.pro_old_id and 
year(sio_date_sold) = Cast(@YR as int)
and sio_date_cancelled is null) 
Order by 1,2;




