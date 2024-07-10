/** How can the performance of various product lines be compared? 
Which products are the most successful, and which ones need improvement or removal?
**/

SELECT 
    pl.productLine, 
    SUM(od.quantityOrdered * p.MSRP) AS totalSales
FROM 
    productlines pl
JOIN 
    products p ON pl.productLine = p.productLine
JOIN 
    orderdetails od ON p.productCode = od.productCode
GROUP BY 
    pl.productLine
ORDER BY 
    totalSales DESC;

