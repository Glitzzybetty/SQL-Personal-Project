 /**3. Is there a relationship between product prices and their sales levels? 
 How can price adjustments impact sales? To check out with regression later
 **/
SELECT 
    p.productCode, 
    p.productName, 
    p.MSRP, cast(round(Avg(od.priceEach), 2) as float) as avgPriceSold,
    SUM(od.quantityOrdered) AS totalQuantitySold
FROM 
    products p
JOIN 
    orderdetails od ON p.productCode = od.productCode
GROUP BY 
    p.productCode, p.productName, p.MSRP
ORDER BY 
     SUM(od.quantityOrdered) desc, p.MSRP, Avg(od.priceEach) desc;
