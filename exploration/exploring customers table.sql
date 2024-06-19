-- Top 5 Countries of Mint Classic customers
select top 5
country, 
count(customerNumber) as [Number of Customers],
round(avg(creditLimit),0) as [Average Credit Limit]
from [mintclassics].[dbo].[customers]
group by country 
order by count(customerNumber) desc

select [jobTitle]
  FROM [mintclassics].[dbo].[employees]