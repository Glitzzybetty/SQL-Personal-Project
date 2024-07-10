/**List customers who have placed more orders than 
the average number of orders placed by all customers.
**/

SELECT 
    c.customerNumber, 
    c.customerName, 
    COUNT(o.orderNumber) as totalOrders
FROM 
    customers c
JOIN 
    orders o ON c.customerNumber = o.customerNumber
GROUP BY 
    c.customerNumber, 
    c.customerName
HAVING 
    COUNT(o.orderNumber) > (
        SELECT 
            AVG(orderCount)
        FROM (
            SELECT 
                COUNT(orderNumber) as orderCount
            FROM 
                orders
            GROUP BY 
                customerNumber
        ) as avgOrders
    )
ORDER BY  COUNT(o.orderNumber) desc

------ We have 98 Distinct Customer Orders who have about 326 orders placed making average of 3
SELECT 
    COUNT(DISTINCT c.customerNumber) AS countCustomers,
    COUNT(o.orderNumber) as totalOrders,
	(COUNT(o.orderNumber) /COUNT(DISTINCT c.customerNumber)) As AvergeOrder
FROM 
    customers c
 JOIN 
    orders o ON c.customerNumber = o.customerNumber