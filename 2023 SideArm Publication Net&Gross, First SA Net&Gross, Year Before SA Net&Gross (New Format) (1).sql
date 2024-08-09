Drop table #temp1
Drop table #temp2 
Drop table #temp3
Drop table #temp3b
Drop table #temp4
Drop table #tempb4
Drop table #temp5

--Gets Net/Gross Total for only 2023 Sidearm sales per institution without cancelled sales 
Select Distinct ins_id, ins_name, yea_year, Sum(dbo.NetSales(sio_id)) Net , Sum(sio_rate) Gross--, pub_wld_call_status--, pub_publication_status
Into #temp1
From sio_table 
inner join yearly_pubs On sio_yea_id = yea_id
inner join publications On yea_pub_id = pub_id
inner join institutions_etc On pub_ins_id = ins_id
Where sio_date_cancelled is null and pub_sa=1 and pub_out_id=150 and yea_year = 2023 
and ins_id in (Select ins_id from publications inner join institutions_etc On pub_ins_id = ins_id Where pub_wld_call_status = 'Main Sell' and pub_sa=1 and pub_out_id=150)
and yea_begin_date is not null
Group by ins_name,  yea_year,ins_id--,pub_wld_call_status,pub_publication_status
Order by 2,3

--Gets all Sidearms totals per institution in the system without cancelled sales
Select ins_id, ins_name, yea_year ,Sum(dbo.NetSales(sio_id)) NetIns, Sum(sio_rate) GrossIns
Into #temp2 
From sio_table 
inner join yearly_pubs On sio_yea_id = yea_id
inner join publications On yea_pub_id = pub_id
inner join institutions_etc On pub_ins_id = ins_id
Where 1 =1 and pub_sa=1 and pub_out_id=150 and sio_date_cancelled is null and 
 ins_id in (Select ins_id from publications inner join institutions_etc On pub_ins_id = ins_id Where pub_wld_call_status = 'Main Sell' and pub_sa=1 and pub_out_id=150)
and yea_begin_date is not null
Group by ins_name,yea_year, ins_id
Order by 2,4

--Gets First SA Year of each institution and Year Before SA
SELECT *, (yea_year - 1) YrB4
into #temp3b
FROM ( SELECT ins_id, ins_name, yea_year, ROW_NUMBER() OVER (PARTITION BY ins_id ORDER BY yea_year asc) AS rn
    FROM #temp2) tmp 
WHERE rn = 1
ORDER BY  ins_name,yea_year;

--Net/Gross Totals for First SA Year of each institution for All pubs in that year w/o cancelled sales
Select ins_id, ins_name, yea_year ,Sum(dbo.NetSales(sio_id)) NetIns, Sum(sio_rate) GrossIns
Into #temp3 
From sio_table 
inner join yearly_pubs On sio_yea_id = yea_id
inner join publications On yea_pub_id = pub_id
inner join institutions_etc On pub_ins_id = ins_id
Where 1 =1 and sio_date_cancelled is null and (Cast(ins_id as varchar) + Cast (yea_year as varchar)) in (Select Cast(ins_id as varchar) + Cast(yea_year as varchar) From #temp3b) 
Group by ins_name,yea_year, ins_id
Order by 2,4

--Net/Gross Total for Year before First SA year per institution without cancelled sales
SELECT ins_id, ins_name, yea_year ,Sum(dbo.NetSales(sio_id)) NetIns, Sum(sio_rate) GrossIns
Into #tempb4
FROM  sio_table 
inner join yearly_pubs On sio_yea_id = yea_id
inner join publications On yea_pub_id = pub_id
inner join institutions_etc On pub_ins_id = ins_id
WHERE (Cast(ins_id as varchar) + Cast (yea_year as varchar)) in (Select Cast(ins_id as varchar) + Cast(YrB4 as varchar) From #temp3b)
and sio_date_cancelled is null 
Group by ins_name,yea_year, ins_id
ORDER BY  ins_name, yea_year


Select *
into #temp5
From #temp1
union
Select ins_id, ins_name, yea_year, NetIns, GrossIns
From #temp3 t2
Union
Select ins_id, ins_name, yea_year, NetIns, GrossIns
From #tempb4 t4
Order by 3, 2

--Final Part 1
Select Distinct t5.ins_name,
ISNULL(Cast ((Select Gross from #temp1 t1 where yea_year = 2023 and t1.ins_id = t5.ins_id)as varchar), '') '2023Gross',
ISNULL(Cast ((Select Net from #temp1 t1 where yea_year = 2023 and t1.ins_id = t5.ins_id)as varchar), '') '2023Net',
stuff((SELECT concat(yea_year, ': ', GrossIns) FROM #temp3 t1 WHERE t1.ins_id = t5.ins_id FOR XML PATH ('')), 1,0,'') 'Total First Yr SA Gross',
stuff((SELECT concat(yea_year, ': ', NetIns) FROM #temp3 t1 WHERE t1.ins_id = t5.ins_id FOR XML PATH ('')), 1,0,'') 'Total First Yr SA Net',
ISNULL(Cast (stuff((SELECT concat(yea_year, ': ', GrossIns) FROM #tempb4 t1 WHERE t1.ins_id = t5.ins_id FOR XML PATH ('')), 1,0,'')as varchar), '') 'Total Yr Before SA Gross',
ISNULL(Cast (stuff((SELECT concat(yea_year, ': ', NetIns) FROM #tempb4 t1 WHERE t1.ins_id = t5.ins_id FOR XML PATH ('')), 1,0,'')as varchar), '') 'Total Yr Before SA Net'
From #temp5 t5




------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Start of Sheet 2 / Part 2 
/*Select  t1.ins_name,'---' g ,'2023 ' + t1.ins_name Institution,'2023 SA Total' Category, isNULL(Cast(Gross as varchar),'-') 'Total Gross', IsNULL(Cast( Net as varchar),'-') 'Total Net', '---'g1,01 a
--into #temp5a
From #temp1 t1
Union
Select  t2.ins_name,'---',Cast (t2.yea_year as varchar)  + ' '+  t2.ins_name Institution, 'Totals for First Year SA', isNULL(Cast(t2.GrossIns as varchar),'-') 'Total Gross',
IsNULL(Cast( t2.NetIns as varchar),'-') 'Total Net', '---', 20 a
From #temp3 t2
Union
Select  t4.ins_name, '---', Cast (t4.yea_year as varchar)  + ' '+  t4.ins_name Institution, 'Totals for Year Before First SA Year' , isNULL(Cast(GrossIns as varchar),'-') 'Total Gross',
IsNULL(Cast( t4.NetIns as varchar),'-') 'Total Net', '---', 30 a
From #tempb4 t4
Order by 1, 4 */

--Gets publications for previous institutions with Net and Gross
Select Distinct ins_id, ins_name, pub_name, yea_year ,Sum(dbo.NetSales(sio_id)) NetIns, Sum(sio_rate) GrossIns, pub_out_id, pub_sa
into #temp4
FROM  sio_table 
inner join yearly_pubs On sio_yea_id = yea_id
inner join publications On yea_pub_id = pub_id
inner join institutions_etc On pub_ins_id = ins_id
Where sio_date_cancelled is null and (ins_name + yea_year) in (Select ins_name +yea_year from #temp5)-- and yea_year in (Select yea_year from #temp5)
Group by ins_name,yea_year, ins_id, pub_name, pub_out_id, pub_sa

--Final Part 2
Select Distinct t5.ins_name a,'---', t5.ins_name, 
ISNULL(Cast ((Select Gross from #temp1 t1 where yea_year = 2023 and t1.ins_id = t5.ins_id)as varchar), '') 'Total 2023 Gross',
ISNULL(Cast ((Select Net from #temp1 t1 where yea_year = 2023 and t1.ins_id = t5.ins_id)as varchar), '') 'Total 2023 Net',
stuff((SELECT concat(yea_year, ': ', GrossIns) FROM #temp3 t1 WHERE t1.ins_id = t5.ins_id FOR XML PATH ('')), 1,0,'') 'Total First Yr SA Gross',
stuff((SELECT concat(yea_year, ': ', NetIns) FROM #temp3 t1 WHERE t1.ins_id = t5.ins_id FOR XML PATH ('')), 1,0,'') 'Total First Yr SA Net',
ISNULL(Cast (stuff((SELECT concat(yea_year, ': ', GrossIns) FROM #tempb4 t1 WHERE t1.ins_id = t5.ins_id FOR XML PATH ('')), 1,0,'')as varchar), '') 'Total Yr Before SA Gross',
ISNULL(Cast (stuff((SELECT concat(yea_year, ': ', NetIns) FROM #tempb4 t1 WHERE t1.ins_id = t5.ins_id FOR XML PATH ('')), 1,0,'')as varchar), '') 'Total Yr Before SA Net','---' ,1
From #temp5 t5
Union
Select Distinct t4.ins_name a,'---',' ', 
ISNULL((Select yea_year from #temp1 t1 Where t4.ins_id = t1.ins_id and t4.yea_year = t1.yea_year) + ' ' + pub_name + ' '+ Cast(GrossIns as varchar),'')'2023 Gross',
ISNULL((Select yea_year from #temp1 t1 Where t4.ins_id = t1.ins_id and t4.yea_year = t1.yea_year) + ' ' + pub_name + ' '+ Cast(NetIns as varchar),'')'2023 Net', 
ISNULL((Select yea_year from #temp3 t2 Where t4.ins_id = t2.ins_id and t4.yea_year = t2.yea_year) + ' ' + pub_name + ' '+ Cast(GrossIns as varchar),'')'First Year Gross',
ISNULL((Select yea_year from #temp3 t2 Where t4.ins_id = t2.ins_id and t4.yea_year = t2.yea_year) + ' ' + pub_name + ' '+ Cast(NetIns as varchar),'')'First YearsNet',
ISNULL((Select yea_year from #tempb4 t3 Where t4.ins_id = t3.ins_id and t4.yea_year = t3.yea_year) + ' ' + pub_name + ' '+ Cast(GrossIns as varchar),'')'Year B4 SA Gross',
ISNULL((Select yea_year from #tempb4 t3 Where t4.ins_id = t3.ins_id and t4.yea_year = t3.yea_year) + ' ' + pub_name + ' '+ Cast(NetIns as varchar),'')'Year B4 SA Net','---', 2
From #temp4 t4
Order by 1,11,8,6




