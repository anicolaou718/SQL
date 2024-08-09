Select pub_name + ' ' + yea_year Publication, Sum(dbo.NetSales(sio_id)) Net, Sum(sio_rate) Gross, sio_date_cancelled
from sio_table
inner join yearly_pubs On sio_yea_id = yea_id
inner join publications On yea_pub_id = pub_id
Where yea_id in (31973505,31973244,31973232,31973543,31973245,31973547,31973545,31973234,31974919,31974912,
31973249,31973546,31973544,31974804,31974924,31974914,31974922,31974928,31974927,31974916,
31974933,31974915,31974926,31974911,31974934,31974913,31974936,31974941,31974935,31974918,
31974937,31973548,31974925,31974910,31974917,31974938,31974931,31974939,31974930)
and sio_date_cancelled is null
Group by pub_name, yea_year,sio_date_cancelled
Order by 1 , 2