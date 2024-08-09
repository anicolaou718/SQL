
---Temps
Drop Table #tempComp
Drop Table #t1
Drop Table #t2
Drop Table #t3
Drop Table #t4
Drop Table #t5
Drop Table #t6


Declare @whileBreaker as integer
set @whileBreaker = 1
Declare @lastDayCheck as datetime
set @lastDayCheck = getdate()
--set @lastDayCheck = '11/15/2023'
while @whileBreaker = 1
	begin
		select @lastDayCheck = DATEADD(DAY, CASE DATENAME(WEEKDAY, @lastDayCheck) 
							WHEN 'Sunday' THEN -2 
							WHEN 'Monday' THEN -3 
							ELSE -1 END, DATEDIFF(DAY, 0, @lastDayCheck))
		if @lastDayCheck not in (select hol_holiday_date from holiday) 
			set @whileBreaker = 0
	end
--set @lastDayCheck = '12/30/21' -- to overwrite, change date and uncommentjohn

select	'::5::'a, @lastDayCheck DaytoCheck, 'today -->'a, getdate()
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



--Gets all cards with contact/company modified the day before that do not belong to dummy users
Select car_id, emp_first_name + ' ' + emp_last_name Employee, spr_phone, spr_phone2, spr_cellular, spr_address1, spr_address2, 
spr_authorize_first_name + ' ' + spr_authorize_last_name Contact, pro_company_name Company, Cast(yea_id as varchar) Publication,
spr_mod_on, emp_id, spr_state, spr_zip, spr_city, pub_name + ' ' + yea_year Publication1
into #tempComp
From Cards
inner join aliases On car_ali_id = ali_id
inner join employees On ali_emp_id = emp_id
inner join sprospect On car_spr_id = spr_id
inner join prospect On spr_pro_id = pro_id
inner join yearly_pubs On car_yea_id = yea_id
inner join publications On yea_pub_id = pub_id
inner join institutions_etc On pub_ins_id = ins_id
inner join region On ins_reg_id = reg_id
Where 1 = 1 and ((spr_mod_on >= @lastDayCheck) or (pro_mod_on >= @lastDayCheck)) and isNUll(emp_dummy,0) = 0
and emp_sale_type in (15,17,127 )
Order by  car_created_on, car_created_by 


Select emp_first_name + ' ' + emp_last_name Employee, spr_phone, spr_phone2, spr_cellular, spr_address1, spr_address2, 
spr_authorize_first_name + ' ' + spr_authorize_last_name Contact, dbo.Strip_Company_name_Full_mp(p1.pro_company_name) Company,
(dbo.Strip_Company_name_Full_mp(p1.pro_company_name)+ Cast(emp_id as varchar) + Cast(yea_id as varchar)) C1,
(dbo.Strip_Address_mp(spr_address1) + Cast(emp_id as varchar) + Cast(yea_id as varchar)) A1,
(dbo.Strip_Address_mp(spr_address2) + Cast(emp_id as varchar) + Cast(yea_id as varchar)) A2,
(Cast(spr_cellular as varchar) + Cast(emp_id as varchar) + Cast(yea_id as varchar)) Cell,
(Cast(spr_phone2 as varchar) + Cast(emp_id as varchar) + Cast(yea_id as varchar)) p2,
(Cast(spr_phone as varchar) + Cast(emp_id as varchar) + Cast(yea_id as varchar)) p1,
Cast(yea_id as varchar) Publication, spr_mod_on, emp_id, car_id, pub_name + ' ' + yea_year Publication1
into #t1
From Cards
inner join yearly_pubs On car_yea_id = yea_id
inner join publications On yea_pub_id = pub_id
inner join aliases On car_ali_id = ali_id
inner join employees On ali_emp_id = emp_id
inner join sprospect s1 On car_spr_id = spr_id
inner join prospect p1 On spr_pro_id = pro_id
Where 1 = 1 and (dbo.Strip_Company_name_Full_mp(p1.pro_company_name)+ Cast(emp_id as varchar) + Cast(yea_id as varchar) in
(Select dbo.Strip_Company_name_Full_mp(tc.Company) + Cast(tc.emp_id as varchar)+Publication From #tempComp tc ) )
and car_id not in (Select car_id From #tempComp tc ) and emp_id in (Select emp_id From #tempComp)


Select emp_first_name + ' ' + emp_last_name Employee, spr_phone, spr_phone2, spr_cellular, spr_address1, spr_address2, 
spr_authorize_first_name + ' ' + spr_authorize_last_name Contact, dbo.Strip_Company_name_Full_mp(p1.pro_company_name) Company,
(dbo.Strip_Company_name_Full_mp(p1.pro_company_name)+ Cast(emp_id as varchar) + Cast(yea_id as varchar)) C1,
(dbo.Strip_Address_mp(spr_address1)  + spr_zip + spr_state + Cast(emp_id as varchar) + Cast(yea_id as varchar)) A1,
(dbo.Strip_Address_mp(spr_address2)  + spr_zip + spr_state + Cast(emp_id as varchar) + Cast(yea_id as varchar)) A2,
(Cast(spr_cellular as varchar) + Cast(emp_id as varchar) + Cast(yea_id as varchar)) Cell,
(Cast(spr_phone2 as varchar) + Cast(emp_id as varchar) + Cast(yea_id as varchar)) p2,
(Cast(spr_phone as varchar) + Cast(emp_id as varchar) + Cast(yea_id as varchar)) p1,
Cast(yea_id as varchar) Publication, spr_mod_on, emp_id, car_id, pub_name + ' ' + yea_year Publication1
into #t3
From Cards
inner join yearly_pubs On car_yea_id = yea_id
inner join publications On yea_pub_id = pub_id
inner join aliases On car_ali_id = ali_id
inner join employees On ali_emp_id = emp_id
inner join sprospect s1 On car_spr_id = spr_id
inner join prospect p1 On spr_pro_id = pro_id
Where 1 = 1 and (dbo.Strip_Address_mp(spr_address1)  + spr_zip + spr_state + Cast(emp_id as varchar) + Cast(yea_id as varchar) in
(Select dbo.Strip_Address_mp(tc.spr_address1)  + spr_zip + spr_state + Cast(tc.emp_id as varchar)+Publication From #tempComp tc Where isNull(spr_address1,'')!= '' ) )
and car_id not in (Select car_id From #tempComp tc ) and emp_id in (Select emp_id From #tempComp)

Select emp_first_name + ' ' + emp_last_name Employee, spr_phone, spr_phone2, spr_cellular, spr_address1, spr_address2, 
spr_authorize_first_name + ' ' + spr_authorize_last_name Contact, dbo.Strip_Company_name_Full_mp(p1.pro_company_name) Company,
(dbo.Strip_Company_name_Full_mp(p1.pro_company_name)+ Cast(emp_id as varchar) + Cast(yea_id as varchar)) C1,
(dbo.Strip_Address_mp(spr_address1) + Cast(emp_id as varchar) + Cast(yea_id as varchar)) A1,
(dbo.Strip_Address_mp(spr_address2) + Cast(emp_id as varchar) + Cast(yea_id as varchar)) A2,
(Cast(spr_cellular as varchar) + Cast(emp_id as varchar) + Cast(yea_id as varchar)) Cell,
(Cast(spr_phone2 as varchar) + Cast(emp_id as varchar) + Cast(yea_id as varchar)) p2,
(Cast(spr_phone as varchar) + Cast(emp_id as varchar) + Cast(yea_id as varchar)) p1,
Cast(yea_id as varchar) Publication, spr_mod_on, emp_id, car_id, pub_name + ' ' + yea_year Publication1
into #t4
From Cards
inner join yearly_pubs On car_yea_id = yea_id
inner join publications On yea_pub_id = pub_id
inner join aliases On car_ali_id = ali_id
inner join employees On ali_emp_id = emp_id
inner join sprospect s1 On car_spr_id = spr_id
inner join prospect p1 On spr_pro_id = pro_id
Where 1 = 1 and ((Cast(s1.spr_cellular as varchar) + Cast(emp_id as varchar) + Cast(yea_id as varchar)) in
(Select Cast(tc.spr_phone as varchar) + Cast(tc.emp_id as varchar)+Publication From #tempComp tc Where isnull(spr_phone,'')!='' ) or
(Cast(s1.spr_cellular as varchar) + Cast(emp_id as varchar) + Cast(yea_id as varchar)) in
(Select Cast(tc.spr_cellular as varchar) + Cast(tc.emp_id as varchar)+Publication From #tempComp tc Where isnull(spr_cellular,'')!='' )
or (Cast(s1.spr_cellular as varchar) + Cast(emp_id as varchar) + Cast(yea_id as varchar)) in
(Select Cast(tc.spr_phone2 as varchar) + Cast(tc.emp_id as varchar)+Publication From #tempComp tc Where isnull(spr_phone2,'')!='' ))
and car_id not in (Select car_id From #tempComp tc ) and emp_id in (Select emp_id From #tempComp)

Select emp_first_name + ' ' + emp_last_name Employee, spr_phone, spr_phone2, spr_cellular, spr_address1, spr_address2, 
spr_authorize_first_name + ' ' + spr_authorize_last_name Contact, dbo.Strip_Company_name_Full_mp(p1.pro_company_name) Company,
(dbo.Strip_Company_name_Full_mp(p1.pro_company_name)+ Cast(emp_id as varchar) + Cast(yea_id as varchar)) C1,
(dbo.Strip_Address_mp(spr_address1) + Cast(emp_id as varchar) + Cast(yea_id as varchar)) A1,
(dbo.Strip_Address_mp(spr_address2) + Cast(emp_id as varchar) + Cast(yea_id as varchar)) A2,
(Cast(spr_cellular as varchar) + Cast(emp_id as varchar) + Cast(yea_id as varchar)) Cell,
(Cast(spr_phone2 as varchar) + Cast(emp_id as varchar) + Cast(yea_id as varchar)) p2,
(Cast(spr_phone as varchar) + Cast(emp_id as varchar) + Cast(yea_id as varchar)) p1,
Cast(yea_id as varchar) Publication, spr_mod_on, emp_id, car_id, pub_name + ' ' + yea_year Publication1
into #t5
From Cards
inner join yearly_pubs On car_yea_id = yea_id
inner join publications On yea_pub_id = pub_id
inner join aliases On car_ali_id = ali_id
inner join employees On ali_emp_id = emp_id
inner join sprospect s1 On car_spr_id = spr_id
inner join prospect p1 On spr_pro_id = pro_id
Where  1=1 and ((Cast(s1.spr_phone2 as varchar) + Cast(emp_id as varchar) + Cast(yea_id as varchar)) in
(Select Cast(tc.spr_phone as varchar) + Cast(tc.emp_id as varchar)+Publication From #tempComp tc Where isnull(spr_phone,'')!='' ) or
(Cast(s1.spr_phone2 as varchar) + Cast(emp_id as varchar) + Cast(yea_id as varchar)) in
(Select Cast(tc.spr_cellular as varchar) + Cast(tc.emp_id as varchar)+Publication From #tempComp tc Where isnull(spr_cellular,'')!='' )
or (Cast(s1.spr_phone2 as varchar) + Cast(emp_id as varchar) + Cast(yea_id as varchar)) in
(Select Cast(tc.spr_phone2 as varchar) + Cast(tc.emp_id as varchar)+Publication From #tempComp tc Where isnull(spr_phone2,'')!='' ))
and car_id not in (Select car_id From #tempComp tc ) and emp_id in (Select emp_id From #tempComp)

Select emp_first_name + ' ' + emp_last_name Employee, spr_phone, spr_phone2, spr_cellular, spr_address1, spr_address2, 
spr_authorize_first_name + ' ' + spr_authorize_last_name Contact, dbo.Strip_Company_name_Full_mp(p1.pro_company_name) Company,
(dbo.Strip_Company_name_Full_mp(p1.pro_company_name)+ Cast(emp_id as varchar) + Cast(yea_id as varchar)) C1,
(dbo.Strip_Address_mp(spr_address1) + Cast(emp_id as varchar) + Cast(yea_id as varchar)) A1,
(dbo.Strip_Address_mp(spr_address2) + Cast(emp_id as varchar) + Cast(yea_id as varchar)) A2,
(Cast(spr_cellular as varchar) + Cast(emp_id as varchar) + Cast(yea_id as varchar)) Cell,
(Cast(spr_phone2 as varchar) + Cast(emp_id as varchar) + Cast(yea_id as varchar)) p2,
(Cast(spr_phone as varchar) + Cast(emp_id as varchar) + Cast(yea_id as varchar)) p1,
Cast(yea_id as varchar) Publication, spr_mod_on, emp_id, car_id, pub_name + ' ' + yea_year Publication1
into #t6
From Cards
inner join yearly_pubs On car_yea_id = yea_id
inner join publications On yea_pub_id = pub_id
inner join aliases On car_ali_id = ali_id
inner join employees On ali_emp_id = emp_id
inner join sprospect s1 On car_spr_id = spr_id
inner join prospect p1 On spr_pro_id = pro_id
Where 1=1 and ((Cast(s1.spr_phone as varchar) + Cast(emp_id as varchar) + Cast(yea_id as varchar)) in
(Select Cast(tc.spr_phone as varchar) + Cast(tc.emp_id as varchar)+Publication From #tempComp tc Where isnull(spr_phone,'')!='' ) or
(Cast(s1.spr_phone as varchar) + Cast(emp_id as varchar) + Cast(yea_id as varchar)) in
(Select Cast(tc.spr_cellular as varchar) + Cast(tc.emp_id as varchar)+Publication From #tempComp tc Where isnull(spr_cellular,'')!='' )
or (Cast(s1.spr_phone as varchar) + Cast(emp_id as varchar) + Cast(yea_id as varchar)) in
(Select Cast(tc.spr_phone2 as varchar) + Cast(tc.emp_id as varchar)+Publication From #tempComp tc Where isnull(spr_phone2,'')!='' ))
and car_id not in (Select car_id From #tempComp ) and emp_id in (Select emp_id From #tempComp)

----------------------------------------------------------------------------------------------------------------------------------
---Same Company Name  in same region
Select '::Company::', emp_first_name + ' ' + emp_last_name Employee, pub_name + ' ' + yea_year Publication1,
dbo.Strip_Company_name_Full_mp(p1.pro_company_name) Company,
spr_phone, spr_phone2, spr_cellular, spr_address1, spr_address2, 
spr_authorize_first_name + ' ' + spr_authorize_last_name Contact,'--------' a,
(dbo.Strip_Company_name_Full_mp(p1.pro_company_name)+ Cast(emp_id as varchar) + Cast(yea_id as varchar)),
Cast(yea_id as varchar) Yea, spr_mod_on, emp_id, car_id, 'y'
From Cards
inner join yearly_pubs On car_yea_id = yea_id
inner join publications On yea_pub_id = pub_id
inner join aliases On car_ali_id = ali_id
inner join employees On ali_emp_id = emp_id
inner join sprospect s1 On car_spr_id = spr_id
inner join prospect p1 On spr_pro_id = pro_id
Where 1 = 1 and (dbo.Strip_Company_name_Full_mp(p1.pro_company_name)+ Cast(emp_id as varchar) + Cast(yea_id as varchar) in (Select C1 From #t1 ) )
and car_id in (Select car_id From #tempComp) and emp_id in (Select emp_id From #t1)
Union
Select '::Company::', emp_first_name + ' ' + emp_last_name Employee, pub_name + ' ' + yea_year Publication1,
dbo.Strip_Company_name_Full_mp(p1.pro_company_name) Company,
spr_phone, spr_phone2, spr_cellular, spr_address1, spr_address2, 
spr_authorize_first_name + ' ' + spr_authorize_last_name Contact,'--------' a,
(dbo.Strip_Company_name_Full_mp(p1.pro_company_name)+ Cast(emp_id as varchar) + Cast(yea_id as varchar)),
Cast(yea_id as varchar) Yea, spr_mod_on, emp_id, car_id, 'x'
--into #t1
From Cards
inner join yearly_pubs On car_yea_id = yea_id
inner join publications On yea_pub_id = pub_id
inner join aliases On car_ali_id = ali_id
inner join employees On ali_emp_id = emp_id
inner join sprospect s1 On car_spr_id = spr_id
inner join prospect p1 On spr_pro_id = pro_id
Where 1 = 1 and car_id in (Select car_id From #t1 ) and emp_id in (Select emp_id From #tempComp)
ORder by  1, 2, 16,  3
------------address1

---Same Address1 in same region for same local employee
Select '::Address::', emp_first_name + ' ' + emp_last_name Employee, pub_name + ' ' + yea_year Publication1, spr_address1, spr_address2, spr_zip, spr_state,
spr_phone, spr_phone2, spr_cellular, dbo.Strip_Company_name_Full_mp(p1.pro_company_name) Company,
spr_authorize_first_name + ' ' + spr_authorize_last_name Contact, '--------' a,
(dbo.Strip_Address_mp(spr_address1) + spr_zip + spr_state + Cast(emp_id as varchar) + Cast(yea_id as varchar)),spr_zip, spr_state,
Cast(yea_id as varchar) Yea, spr_mod_on, emp_id, car_id, 'y'
From Cards
inner join yearly_pubs On car_yea_id = yea_id
inner join publications On yea_pub_id = pub_id
inner join aliases On car_ali_id = ali_id
inner join employees On ali_emp_id = emp_id
inner join sprospect s1 On car_spr_id = spr_id
inner join prospect p1 On spr_pro_id = pro_id
Where 1 = 1 and (dbo.Strip_Address_mp(spr_address1)  + spr_zip + spr_state + Cast(emp_id as varchar) + Cast(yea_id as varchar) in (Select A1 From #t3 ) )
and car_id in (Select car_id From #tempComp) and emp_id in (Select emp_id From #t3)
Union
Select '::Address::', emp_first_name + ' ' + emp_last_name Employee, pub_name + ' ' + yea_year Publication1, spr_address1, spr_address2, spr_zip, spr_state,
spr_phone, spr_phone2, spr_cellular, dbo.Strip_Company_name_Full_mp(p1.pro_company_name) Company,
spr_authorize_first_name + ' ' + spr_authorize_last_name Contact, '--------' a,
(dbo.Strip_Address_mp(spr_address1) + spr_zip + spr_state + Cast(emp_id as varchar) + Cast(yea_id as varchar)),spr_zip, spr_state,
Cast(yea_id as varchar) Yea, spr_mod_on, emp_id, car_id, 'x'
From Cards
inner join yearly_pubs On car_yea_id = yea_id
inner join publications On yea_pub_id = pub_id
inner join aliases On car_ali_id = ali_id
inner join employees On ali_emp_id = emp_id
inner join sprospect s1 On car_spr_id = spr_id
inner join prospect p1 On spr_pro_id = pro_id
Where 1 = 1 and car_id in (Select car_id From #t3 ) and emp_id in (Select emp_id From #tempComp)
ORder by  1, 2, 16, 3
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------phone1------------phone2-----------cellular
---Same Phone1 in same region for same local employee
Select '::Phone1::', emp_first_name + ' ' + emp_last_name Employee, pub_name + ' ' + yea_year Publication1, spr_phone, spr_phone2, spr_cellular,
dbo.Strip_Company_name_Full_mp(p1.pro_company_name) Company,spr_address1, spr_address2, spr_zip, spr_state, 
spr_authorize_first_name + ' ' + spr_authorize_last_name Contact, '--------' a,
Case When (Cast(s1.spr_phone as varchar) + Cast(emp_id as varchar) + Cast(yea_id as varchar)) in (Select p1 From #t6)
Then (Cast(s1.spr_phone as varchar) + Cast(emp_id as varchar) + Cast(yea_id as varchar))
When (Cast(s1.spr_phone2 as varchar) + Cast(emp_id as varchar) + Cast(yea_id as varchar)) in (Select p1 From #t6)
Then (Cast(s1.spr_phone2 as varchar) + Cast(emp_id as varchar) + Cast(yea_id as varchar))
When (Cast(s1.spr_cellular as varchar) + Cast(emp_id as varchar) + Cast(yea_id as varchar)) in (Select p1 From #t6)
Then(Cast(s1.spr_cellular as varchar) + Cast(emp_id as varchar) + Cast(yea_id as varchar)) end,
Cast(yea_id as varchar) Yea, spr_mod_on, emp_id, car_id, 'a'--, (Select p1 From #t6 t6 Where t6.emp_id = emp_id and Publication = yea_id)
From Cards c1
inner join yearly_pubs p On car_yea_id = yea_id
inner join publications  On yea_pub_id = pub_id
inner join aliases On car_ali_id = ali_id
inner join employees e1 On ali_emp_id = emp_id
inner join sprospect s1 On car_spr_id = spr_id
inner join prospect p1 On spr_pro_id = pro_id
Where 1 = 1 and (Cast(s1.spr_phone as varchar) + Cast(emp_id as varchar) + Cast(yea_id as varchar) in (Select p1 From #t6 ) or
Cast(s1.spr_phone as varchar) + Cast(emp_id as varchar) + Cast(yea_id as varchar) in (Select p2 From #t6 ) or
Cast(s1.spr_phone as varchar) + Cast(emp_id as varchar) + Cast(yea_id as varchar) in (Select Cell From #t6 ))
and car_id in (Select car_id From #tempComp ) and emp_id in (Select emp_id From #t6)
Union
Select '::Phone1::', emp_first_name + ' ' + emp_last_name Employee, pub_name + ' ' + yea_year Publication1, spr_phone, spr_phone2, spr_cellular,
dbo.Strip_Company_name_Full_mp(p1.pro_company_name) Company,spr_address1, spr_address2, spr_zip, spr_state, 
spr_authorize_first_name + ' ' + spr_authorize_last_name Contact, '--------' a,
(Cast(s1.spr_phone as varchar) + Cast(emp_id as varchar) + Cast(yea_id as varchar)),
Cast(yea_id as varchar) Yea, spr_mod_on, emp_id, car_id, 'b'
From Cards
inner join yearly_pubs On car_yea_id = yea_id
inner join publications On yea_pub_id = pub_id
inner join aliases On car_ali_id = ali_id
inner join employees On ali_emp_id = emp_id
inner join sprospect s1 On car_spr_id = spr_id
inner join prospect p1 On spr_pro_id = pro_id
Where 1 = 1 and car_id in (Select car_id From #t6 ) and emp_id in (Select emp_id From #tempComp)
union
Select '::Phone2::', emp_first_name + ' ' + emp_last_name Employee, pub_name + ' ' + yea_year Publication1, spr_phone, spr_phone2, spr_cellular,
dbo.Strip_Company_name_Full_mp(p1.pro_company_name) Company,spr_address1, spr_address2, spr_zip, spr_state, 
spr_authorize_first_name + ' ' + spr_authorize_last_name Contact, '--------' a,
Case When (Cast(s1.spr_phone as varchar) + Cast(emp_id as varchar) + Cast(yea_id as varchar)) in (Select p2 From #t5)
Then (Cast(s1.spr_phone as varchar) + Cast(emp_id as varchar) + Cast(yea_id as varchar))
When (Cast(s1.spr_phone2 as varchar) + Cast(emp_id as varchar) + Cast(yea_id as varchar)) in (Select p2 From #t5)
Then (Cast(s1.spr_phone2 as varchar) + Cast(emp_id as varchar) + Cast(yea_id as varchar))
When (Cast(s1.spr_cellular as varchar) + Cast(emp_id as varchar) + Cast(yea_id as varchar)) in (Select p2 From #t5)
Then(Cast(s1.spr_cellular as varchar) + Cast(emp_id as varchar) + Cast(yea_id as varchar)) end,
Cast(yea_id as varchar) Yea, spr_mod_on, emp_id, car_id, 'c'
From Cards
inner join yearly_pubs On car_yea_id = yea_id
inner join publications On yea_pub_id = pub_id
inner join aliases On car_ali_id = ali_id
inner join employees On ali_emp_id = emp_id
inner join sprospect s1 On car_spr_id = spr_id
inner join prospect p1 On spr_pro_id = pro_id
Where 1 = 1 and (Cast(s1.spr_phone2 as varchar) + Cast(emp_id as varchar) + Cast(yea_id as varchar) in (Select p2 From #t5 ) or 
Cast(s1.spr_phone2 as varchar) + Cast(emp_id as varchar) + Cast(yea_id as varchar) in (Select p1 From #t5 ) or
Cast(s1.spr_phone2 as varchar) + Cast(emp_id as varchar) + Cast(yea_id as varchar) in (Select Cell From #t5 ))
and car_id in (Select car_id From #tempComp ) and emp_id in (Select emp_id From #t5)-- and car_id not in (Select car_id From #t4)
Union
Select '::Phone2::', emp_first_name + ' ' + emp_last_name Employee, pub_name + ' ' + yea_year Publication1, spr_phone, spr_phone2, spr_cellular,
dbo.Strip_Company_name_Full_mp(p1.pro_company_name) Company,spr_address1, spr_address2, spr_zip, spr_state, 
spr_authorize_first_name + ' ' + spr_authorize_last_name Contact, '--------' a,
(Cast(s1.spr_phone2 as varchar) + Cast(emp_id as varchar) + Cast(yea_id as varchar)),
Cast(yea_id as varchar) Yea, spr_mod_on, emp_id, car_id, 'd'
From Cards
inner join yearly_pubs On car_yea_id = yea_id
inner join publications On yea_pub_id = pub_id
inner join aliases On car_ali_id = ali_id
inner join employees On ali_emp_id = emp_id
inner join sprospect s1 On car_spr_id = spr_id
inner join prospect p1 On spr_pro_id = pro_id
Where 1 = 1 and car_id in (Select car_id From #t5 ) and emp_id in (Select emp_id From #tempComp)
union
Select '::Cellular::', emp_first_name + ' ' + emp_last_name Employee, pub_name + ' ' + yea_year Publication1, spr_phone, spr_phone2, spr_cellular,
dbo.Strip_Company_name_Full_mp(p1.pro_company_name) Company,spr_address1, spr_address2, spr_zip, spr_state, 
spr_authorize_first_name + ' ' + spr_authorize_last_name Contact, '--------' a,
Case When (Cast(s1.spr_phone as varchar) + Cast(emp_id as varchar) + Cast(yea_id as varchar)) in (Select Cell From #t4)
Then (Cast(s1.spr_phone as varchar) + Cast(emp_id as varchar) + Cast(yea_id as varchar))
When (Cast(s1.spr_phone2 as varchar) + Cast(emp_id as varchar) + Cast(yea_id as varchar)) in (Select Cell From #t4)
Then (Cast(s1.spr_phone2 as varchar) + Cast(emp_id as varchar) + Cast(yea_id as varchar))
When (Cast(s1.spr_cellular as varchar) + Cast(emp_id as varchar) + Cast(yea_id as varchar)) in (Select Cell From #t4)
Then(Cast(s1.spr_cellular as varchar) + Cast(emp_id as varchar) + Cast(yea_id as varchar)) end,
Cast(yea_id as varchar) Yea, spr_mod_on, emp_id, car_id, 'e'
From Cards
inner join yearly_pubs On car_yea_id = yea_id
inner join publications On yea_pub_id = pub_id
inner join aliases On car_ali_id = ali_id
inner join employees On ali_emp_id = emp_id
inner join sprospect s1 On car_spr_id = spr_id
inner join prospect p1 On spr_pro_id = pro_id
Where 1 = 1 and (Cast(s1.spr_cellular as varchar) + Cast(emp_id as varchar) + Cast(yea_id as varchar) in (Select Cell From #t4 ) or
Cast(s1.spr_cellular as varchar) + Cast(emp_id as varchar) + Cast(yea_id as varchar) in (Select p1 From #t4 )  or
Cast(s1.spr_cellular as varchar) + Cast(emp_id as varchar) + Cast(yea_id as varchar) in (Select p2 From #t4 ) )
and car_id in (Select car_id From #tempComp ) and emp_id in (Select emp_id From #t4)
Union
Select  '::Cellular::', emp_first_name + ' ' + emp_last_name Employee, pub_name + ' ' + yea_year Publication1, spr_phone, spr_phone2, spr_cellular,
dbo.Strip_Company_name_Full_mp(p1.pro_company_name) Company,spr_address1, spr_address2, spr_zip, spr_state, 
spr_authorize_first_name + ' ' + spr_authorize_last_name Contact, '--------' a,
(Cast(s1.spr_cellular as varchar) + Cast(emp_id as varchar) + Cast(yea_id as varchar)),
Cast(yea_id as varchar) Yea, spr_mod_on, emp_id, car_id,'f'
From Cards
inner join yearly_pubs On car_yea_id = yea_id
inner join publications On yea_pub_id = pub_id
inner join aliases On car_ali_id = ali_id
inner join employees On ali_emp_id = emp_id
inner join sprospect s1 On car_spr_id = spr_id
inner join prospect p1 On spr_pro_id = pro_id
Where 1 = 1 and car_id in (Select car_id From #t4 ) and emp_id in (Select emp_id From #tempComp)
Order by 2,3,14,19

/*
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------phone1------------phone2-----------cellular
---Same Phone1 in same region for same local employee
Select '::Phone1::', emp_first_name + ' ' + emp_last_name Employee, pub_name + ' ' + yea_year Publication1, spr_phone, spr_phone2, spr_cellular,
dbo.Strip_Company_name_Full_mp(p1.pro_company_name) Company,spr_address1, spr_address2, spr_zip, spr_state, 
spr_authorize_first_name + ' ' + spr_authorize_last_name Contact, '--------' a,
Case When (Cast(s1.spr_phone as varchar) + Cast(emp_id as varchar) + Cast(yea_id as varchar)) in (Select p1 From #t6)
Then (Cast(s1.spr_phone as varchar) + Cast(emp_id as varchar) + Cast(yea_id as varchar))
When (Cast(s1.spr_phone2 as varchar) + Cast(emp_id as varchar) + Cast(yea_id as varchar)) in (Select p1 From #t6)
Then (Cast(s1.spr_phone2 as varchar) + Cast(emp_id as varchar) + Cast(yea_id as varchar))
When (Cast(s1.spr_cellular as varchar) + Cast(emp_id as varchar) + Cast(yea_id as varchar)) in (Select p1 From #t6)
Then(Cast(s1.spr_cellular as varchar) + Cast(emp_id as varchar) + Cast(yea_id as varchar)) end,
Cast(yea_id as varchar) Yea, spr_mod_on, emp_id, car_id, 'a'--, (Select p1 From #t6 t6 Where t6.emp_id = emp_id and Publication = yea_id)
From Cards c1
inner join yearly_pubs p On car_yea_id = yea_id
inner join publications  On yea_pub_id = pub_id
inner join aliases On car_ali_id = ali_id
inner join employees e1 On ali_emp_id = emp_id
inner join sprospect s1 On car_spr_id = spr_id
inner join prospect p1 On spr_pro_id = pro_id
Where 1 = 1 and (Cast(s1.spr_phone as varchar) + Cast(emp_id as varchar) + Cast(yea_id as varchar) in (Select p1 From #t6 ) or
Cast(s1.spr_cellular as varchar) + Cast(emp_id as varchar) + Cast(yea_id as varchar) in (Select p1 From #t6 ) or
Cast(s1.spr_phone2 as varchar) + Cast(emp_id as varchar) + Cast(yea_id as varchar) in (Select p1 From #t6 ))
and car_id in (Select car_id From #tempComp ) and emp_id in (Select emp_id From #t6)
Union
Select '::Phone1::', emp_first_name + ' ' + emp_last_name Employee, pub_name + ' ' + yea_year Publication1, spr_phone, spr_phone2, spr_cellular,
dbo.Strip_Company_name_Full_mp(p1.pro_company_name) Company,spr_address1, spr_address2, spr_zip, spr_state, 
spr_authorize_first_name + ' ' + spr_authorize_last_name Contact, '--------' a,
(Cast(s1.spr_phone as varchar) + Cast(emp_id as varchar) + Cast(yea_id as varchar)),
Cast(yea_id as varchar) Yea, spr_mod_on, emp_id, car_id, 'b'
From Cards
inner join yearly_pubs On car_yea_id = yea_id
inner join publications On yea_pub_id = pub_id
inner join aliases On car_ali_id = ali_id
inner join employees On ali_emp_id = emp_id
inner join sprospect s1 On car_spr_id = spr_id
inner join prospect p1 On spr_pro_id = pro_id
Where 1 = 1 and car_id in (Select car_id From #t6 ) and emp_id in (Select emp_id From #tempComp)
union
Select '::Phone2::', emp_first_name + ' ' + emp_last_name Employee, pub_name + ' ' + yea_year Publication1, spr_phone, spr_phone2, spr_cellular,
dbo.Strip_Company_name_Full_mp(p1.pro_company_name) Company,spr_address1, spr_address2, spr_zip, spr_state, 
spr_authorize_first_name + ' ' + spr_authorize_last_name Contact, '--------' a,
Case When (Cast(s1.spr_phone as varchar) + Cast(emp_id as varchar) + Cast(yea_id as varchar)) in (Select p2 From #t5)
Then (Cast(s1.spr_phone as varchar) + Cast(emp_id as varchar) + Cast(yea_id as varchar))
When (Cast(s1.spr_phone2 as varchar) + Cast(emp_id as varchar) + Cast(yea_id as varchar)) in (Select p2 From #t5)
Then (Cast(s1.spr_phone2 as varchar) + Cast(emp_id as varchar) + Cast(yea_id as varchar))
When (Cast(s1.spr_cellular as varchar) + Cast(emp_id as varchar) + Cast(yea_id as varchar)) in (Select p2 From #t5)
Then(Cast(s1.spr_cellular as varchar) + Cast(emp_id as varchar) + Cast(yea_id as varchar)) end,
Cast(yea_id as varchar) Yea, spr_mod_on, emp_id, car_id, 'c'
From Cards
inner join yearly_pubs On car_yea_id = yea_id
inner join publications On yea_pub_id = pub_id
inner join aliases On car_ali_id = ali_id
inner join employees On ali_emp_id = emp_id
inner join sprospect s1 On car_spr_id = spr_id
inner join prospect p1 On spr_pro_id = pro_id
Where 1 = 1 and (Cast(s1.spr_phone2 as varchar) + Cast(emp_id as varchar) + Cast(yea_id as varchar) in (Select p2 From #t5 ) or 
Cast(s1.spr_phone as varchar) + Cast(emp_id as varchar) + Cast(yea_id as varchar) in (Select p2 From #t5 ) or
Cast(s1.spr_cellular as varchar) + Cast(emp_id as varchar) + Cast(yea_id as varchar) in (Select p2 From #t5 ))
and car_id in (Select car_id From #tempComp ) and emp_id in (Select emp_id From #t5)-- and car_id not in (Select car_id From #t4)
Union
Select '::Phone2::', emp_first_name + ' ' + emp_last_name Employee, pub_name + ' ' + yea_year Publication1, spr_phone, spr_phone2, spr_cellular,
dbo.Strip_Company_name_Full_mp(p1.pro_company_name) Company,spr_address1, spr_address2, spr_zip, spr_state, 
spr_authorize_first_name + ' ' + spr_authorize_last_name Contact, '--------' a,
(Cast(s1.spr_phone2 as varchar) + Cast(emp_id as varchar) + Cast(yea_id as varchar)),
Cast(yea_id as varchar) Yea, spr_mod_on, emp_id, car_id, 'd'
From Cards
inner join yearly_pubs On car_yea_id = yea_id
inner join publications On yea_pub_id = pub_id
inner join aliases On car_ali_id = ali_id
inner join employees On ali_emp_id = emp_id
inner join sprospect s1 On car_spr_id = spr_id
inner join prospect p1 On spr_pro_id = pro_id
Where 1 = 1 and car_id in (Select car_id From #t5 ) and emp_id in (Select emp_id From #tempComp)
union
Select '::Cellular::', emp_first_name + ' ' + emp_last_name Employee, pub_name + ' ' + yea_year Publication1, spr_phone, spr_phone2, spr_cellular,
dbo.Strip_Company_name_Full_mp(p1.pro_company_name) Company,spr_address1, spr_address2, spr_zip, spr_state, 
spr_authorize_first_name + ' ' + spr_authorize_last_name Contact, '--------' a,
Case When (Cast(s1.spr_phone as varchar) + Cast(emp_id as varchar) + Cast(yea_id as varchar)) in (Select Cell From #t4)
Then (Cast(s1.spr_phone as varchar) + Cast(emp_id as varchar) + Cast(yea_id as varchar))
When (Cast(s1.spr_phone2 as varchar) + Cast(emp_id as varchar) + Cast(yea_id as varchar)) in (Select Cell From #t4)
Then (Cast(s1.spr_phone2 as varchar) + Cast(emp_id as varchar) + Cast(yea_id as varchar))
When (Cast(s1.spr_cellular as varchar) + Cast(emp_id as varchar) + Cast(yea_id as varchar)) in (Select Cell From #t4)
Then(Cast(s1.spr_cellular as varchar) + Cast(emp_id as varchar) + Cast(yea_id as varchar)) end,
Cast(yea_id as varchar) Yea, spr_mod_on, emp_id, car_id, 'e'
From Cards
inner join yearly_pubs On car_yea_id = yea_id
inner join publications On yea_pub_id = pub_id
inner join aliases On car_ali_id = ali_id
inner join employees On ali_emp_id = emp_id
inner join sprospect s1 On car_spr_id = spr_id
inner join prospect p1 On spr_pro_id = pro_id
Where 1 = 1 and (Cast(s1.spr_cellular as varchar) + Cast(emp_id as varchar) + Cast(yea_id as varchar) in (Select Cell From #t4 ) or
Cast(s1.spr_phone2 as varchar) + Cast(emp_id as varchar) + Cast(yea_id as varchar) in (Select Cell From #t4 )  or
Cast(s1.spr_phone as varchar) + Cast(emp_id as varchar) + Cast(yea_id as varchar) in (Select Cell From #t4 ) )
and car_id in (Select car_id From #tempComp ) and emp_id in (Select emp_id From #t4)
Union
Select  '::Cellular::', emp_first_name + ' ' + emp_last_name Employee, pub_name + ' ' + yea_year Publication1, spr_phone, spr_phone2, spr_cellular,
dbo.Strip_Company_name_Full_mp(p1.pro_company_name) Company,spr_address1, spr_address2, spr_zip, spr_state, 
spr_authorize_first_name + ' ' + spr_authorize_last_name Contact, '--------' a,
(Cast(s1.spr_cellular as varchar) + Cast(emp_id as varchar) + Cast(yea_id as varchar)),
Cast(yea_id as varchar) Yea, spr_mod_on, emp_id, car_id,'f'
From Cards
inner join yearly_pubs On car_yea_id = yea_id
inner join publications On yea_pub_id = pub_id
inner join aliases On car_ali_id = ali_id
inner join employees On ali_emp_id = emp_id
inner join sprospect s1 On car_spr_id = spr_id
inner join prospect p1 On spr_pro_id = pro_id
Where 1 = 1 and car_id in (Select car_id From #t4 ) and emp_id in (Select emp_id From #tempComp)
Order by 2,3,14,19*/