--Find sio_id of the sale for the complementary book order and plug it in. Then delete or change bdo record!!
Select *
--Update bdo_book_detail set bdo_quantity = 2
--Delete
From bdo_book_detail
inner join bho_book_header On bdo_bho_id = bho_id
Where bho_sio_id = 910000828 --and bdo_id = 910001233
--begin tran
--rollback
--commit