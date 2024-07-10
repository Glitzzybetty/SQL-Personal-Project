/**6. How can customer payment trends be analyzed?
What credit risks should be monitored, and how can cash flow be managed?
**/

WITH payment_trends AS (
    SELECT 
        c.customerNumber, 
        c.customerName, 
        COUNT(p.[checkNumber]) AS totalPayments, 
        SUM(p.amount) AS totalAmountPaid
    FROM 
        customers c
    JOIN 
        payments p ON c.customerNumber = p.customerNumber
    GROUP BY 
        c.customerNumber, c.customerName
)
SELECT 
    customerNumber, 
    customerName, 
    totalPayments, 
    totalAmountPaid
FROM 
    payment_trends
ORDER BY 
    totalPayments DESC;
