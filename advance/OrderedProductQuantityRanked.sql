--Find the top 3 products with the highest quantity ordered for each order.
-- Need to check order cummulTIVE BY date.
with ProductOrdersQuantityRank as (SELECT 
    orderNumber, 
    productCode, 
    quantityOrdered, 
    --RANK() OVER (PARTITION BY orderNumber ORDER BY quantityOrdered DESC) as rankOrder
	RANK() OVER (ORDER BY quantityOrdered DESC) AS rankOrder

FROM 
    orderdetails)
SELECT * 
FROM
	ProductOrdersQuantityRank
WHERE 
	rankOrder <= 3;


-----Checking TOP 10 PRODUCT quantity Ordered
--SELECT TOP 10
--    --orderNumber, 
--    productCode, 
--    SUM(quantityOrdered) AS [Total Quantity Ordered]
--FROM 
--    orderdetails
--GROUP BY 
--	--orderNumber, 
--    productCode
--ORDER BY SUM(quantityOrdered) desc

