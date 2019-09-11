
CREATE VIEW V_Invoice_MonthlyInvoices AS
SELECT Month([Date]) AS [Month], YEAR([Date]) AS [Year], FORMAT(SUM(Total),'$ ###,###.##') AS [Invoice Total]
FROM Invoice
GROUP BY Month([Date]), YEAR([Date])