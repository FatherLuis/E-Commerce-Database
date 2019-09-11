

CREATE VIEW V_Order_MonthlySales AS

SELECT Month([Date]) AS [Month], YEAR([Date]) AS [Year], FORMAT(SUM(Total),'$ ###,###.##') AS [Invoice Total]
FROM [Order]
GROUP BY Month([Date]), YEAR([Date])






