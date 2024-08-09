--1)  Count of NEW card requests for the day.
SELECT cre_company_name Company, cre_first_name + ' ' + cre_last_name Contact, cre_request_date 'Request Date'
FROM crequest
WHERE (cre_request_date >= CONVERT(DATETIME, '2023-1-01 00:00:00', 102))
AND (cre_emp_id_orig = 995)
AND (cre_type = 'NEW')  


SELECT MONTH(cre_request_date) As 'Month', count(cre_id) As 'Number of Requests'
FROM crequest
WHERE (cre_request_date >= CONVERT(DATETIME, '2023-1-01 00:00:00', 102))
AND (cre_emp_id_orig = 995)
AND (cre_type = 'NEW')  
Group by MONTH(cre_request_date)


--1)  Count of NEW card requests for the day.

SELECT COUNT(cre_id)
FROM crequest
WHERE (cre_request_date >= CONVERT(DATETIME, '2017-04-05 00:00:00', 102)) ----your date or dates go here...
AND (cre_emp_id_orig = 5015) --- your emp_id goes here
AND (cre_type = 'NEW')  

--2) Count of Name Change requests 
SELECT COUNT(cre_id)
FROM crequest
WHERE (cre_request_date >= CONVERT(DATETIME, '2017-04-05 00:00:00', 102)) ----your date or dates go here...
AND (cre_emp_id_orig = 5015) --- your emp_id goes here
AND (cre_type = 'CHCI')

--3) number of rejected card request (new and change/add contact name requests):

SELECT COUNT(cre_id)
FROM crequest
WHERE (cre_request_date >= CONVERT(DATETIME, '2017-04-05 00:00:00', 102)) ----your date or dates go here...
AND (cre_emp_id_orig = 5015) --- your emp_id goes here
AND  (cre_status IN (2))
AND (cre_type IN ('NEW','CHCI')) 