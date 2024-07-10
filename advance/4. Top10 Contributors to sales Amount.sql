/*4. Who are the customers contributing the most to sales? 
How can we focus sales efforts on these valuable customers?
*/
SELECT TOP 10
    c.customerNumber, 
    c.customerName, 
	c.[country],
    SUM(od.quantityOrdered * p.MSRP) AS totalSales
FROM 
    customers c
JOIN 
    orders o ON c.customerNumber = o.customerNumber
JOIN 
    orderdetails od ON o.orderNumber = od.orderNumber
JOIN 
    products p ON od.productCode = p.productCode
GROUP BY 
    c.customerNumber, c.customerName, c.[country]
ORDER BY 
    totalSales DESC
--LIMIT 10; Use in PosgresDB
