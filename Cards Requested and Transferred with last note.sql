
Drop table #creAtl
SELECT  Distinct Req_Status, eName_orig, pub_name_orig, cre_company_name_orig, cre_created_on, cre_car_id, cre_id, cre_accepted_on, cre_emp_sale_type--, *
into #creAtl
FROM            vwrptCrequestBase
WHERE        (cre_status IN (1, 2))
AND (cre_created_on >= CONVERT(DATETIME, '2024-03-15 00:00:00', 102) and cre_created_on < CONVERT(DATETIME, '2024-4-18 00:00:00', 102))
AND (cre_type = 'new')
--AND (cre_emp_sale_type in (17))-- and cre_car_id not in (Select cre_car_id From #t)
ORDER BY 5

Drop table #AllNotes
Select not_id,cre_car_id, g1.eName_orig,g1.cre_company_name_orig, g1.Req_Status,cre_accepted_on, g1.pub_name_orig, not_notes Last_Notes, Not_seq not_seq, cre_created_on, cre_id,
(Select car_transferred_date From cards Where car_id = cre_car_id) As Transferred, (Select car_transferred_by_emp_id From cards Where car_id = cre_car_id) As TransferredBy--, cre_emp_sale_type
Into #AllNotes
from notes
right join #creAtl g1 On cre_car_id = not_car_id 
Order by 5


Select Distinct *
From (Select t.*,
row_number() over (partition by cre_id order by not_seq desc) As seqnum from #AllNotes t ) t
where seqnum in (1) and TransferredBy = 10458
Order by 3,10,4 --and (Invoice-Payment) > 0 Order By pro_old_id



SELECT Distinct Req_Status, eName_orig, pub_name_orig, cre_company_name_orig, cre_created_on, cre_car_id,cre_accepted_on,cre_emp_id_orig,
cre_emp_id,cre_card_requester_emp_id_orig--,*
FROM vwrptCrequestBase
WHERE (cre_status IN (1, 2))
AND (cre_created_on >= CONVERT(DATETIME, '2023-11-28 00:00:00', 102) and cre_created_on< CONVERT(DATETIME, '2023-12-01 00:00:00', 102))
AND (cre_type = 'new')
AND (cre_emp_sale_type in (17))
ORDER BY 3,4