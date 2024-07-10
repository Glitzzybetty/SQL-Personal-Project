/** 
1. Are there products with high inventory but low sales? 
How can we optimize the inventory of these products?
MSRP means Manufacturer suggested Retail Price 
**/
WITH product_sales AS (
    SELECT 
        p.productCode, 
        p.productName, 
        p.quantityInStock,
        ISNULL(SUM(od.quantityOrdered), 0) AS totalQuantitySold,
        ISNULL(SUM(od.quantityOrdered * od.priceEach) / NULLIF(AVG(p.quantityInStock), 0), 1) AS InventoryTurnOverRatio,
        ISNULL(AVG(p.quantityInStock) / NULLIF(SUM(od.quantityOrdered * od.priceEach), 0), 1) AS StockToSalesRatio
    FROM 
        products p
    LEFT JOIN 
        orderdetails od ON p.productCode = od.productCode
    GROUP BY 
        p.productCode, p.productName, p.quantityInStock, p.MSRP
)
SELECT TOP 10
    productCode, 
    productName, 
    quantityInStock, 
    totalQuantitySold,
    InventoryTurnOverRatio, 
    CAST(ROUND(StockToSalesRatio, 2) AS float) AS StockToSalesRatio
FROM 
    product_sales
ORDER BY 
    StockToSalesRatio DESC;


	-------------------------------------
--	/**1. Are there products with high inventory but low sales?
--How can we optimize the inventory of these products?
--MSRP means Manufacturer suggested Retail Price
--**/
--WITH product_sales AS (
--    SELECT 
--        p.productCode, 
--        p.productName, 
--		p.quantityInStock,
--       -- AVG(p.quantityInStock) as [Average Inventory],  
--		--(p.quantityInStock * p.MSRP) as quantityInStockValue,
--		--SUM(od.quantityOrdered * od.priceEach) as totalQuantitySoldValue, --COGS
--        ISNULL(SUM(od.quantityOrdered),0) AS totalQuantitySold,
--		ISNULL(SUM(od.quantityOrdered * od.priceEach)/AVG(p.quantityInStock),1) as [InventoryTurnOverRatio],
--		ISNULL(AVG(p.quantityInStock)/ SUM(od.quantityOrdered * od.priceEach),1) as [Stock to Sale Ratio]
--    FROM 
--        products p
--    LEFT JOIN 
--        orderdetails od ON p.productCode = od.productCode
--    GROUP BY 
--        p.productCode, p.productName, p.quantityInStock, p.MSRP
--)
--SELECT TOP 10
--    productCode, 
--    productName, 
--    quantityInStock, 
--    totalQuantitySold,
--	[InventoryTurnOverRatio], 
--	CAST(ROUND([Stock to Sale Ratio], 2) AS float) [Stock to Sale Ratio]
--FROM 
--    product_sales
----WHERE 
----    quantityInStock >  totalQuantitySold 
----	AND productName = '1985 Toyota Supra'
--ORDER BY [Stock to Sale Ratio] desc
-----[InventoryTurnOverRatio];
