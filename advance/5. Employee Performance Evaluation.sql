/** 5. How can sales employee performance be evaluated using sales data?
**/

WITH employee_sales AS (
    SELECT 
        e.employeeNumber, 
        e.firstName, 
        e.lastName, 
		SUM(od.quantityOrdered) as quantityOrderedtotal,
        SUM(od.quantityOrdered * p.MSRP) AS totalSales
    FROM 
        employees e
    JOIN 
        customers c ON e.employeeNumber = c.salesRepEmployeeNumber
    JOIN 
        orders o ON c.customerNumber = o.customerNumber
    JOIN 
        orderdetails od ON o.orderNumber = od.orderNumber
    JOIN 
        products p ON od.productCode = p.productCode
    GROUP BY 
        e.employeeNumber, e.firstName, e.lastName
)
SELECT 
    employeeNumber, 
    firstName, 
    lastName, 
	quantityOrderedtotal,
    totalSales,
	cast(round(totalSales/quantityOrderedtotal,0) as float) AS Productivity
FROM 
    employee_sales
ORDER BY 
    totalSales DESC;
