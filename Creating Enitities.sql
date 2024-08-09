Select *
From Entity
where ent_id = 13 --ent_name like '%Kashi%'--ent_parent_id =13


Select *
From EntityTable

select * from Entity 
where ent_unique_id > ( select ent_unique_id from Entity where ent_name = 'MCZ Realty Holdings' ) 
and ent_unique_id < ( select ent_next_unique_id from Entity where ent_name = 'MCZ Realty Holdings')
order by 2

select * from entityTable
where ent_parent_id = 10 and ent_child_num = 2


Select *
from Accounts


Select * From Accounts 
inner join coa On coa_acc_id = acc_id
where coa_id =690000033

--insert into coa (coa_ent_id, coa_acc_id)
select   ent_id, acc_id
from entity,
(select ent_id as dtfEntity,acc_id , ent_name as dtfEntityName
from entitytable  inner join Accounts on acc_id = ent_due_to_from_acc_id)a
where ent_id <> dtfEntity
and not exists( select * from coa where coa_acc_id = acc_id and coa_ent_id = ent_id)
order by ent_id, dtfEntity


