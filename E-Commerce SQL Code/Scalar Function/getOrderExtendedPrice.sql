
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create Function [getOrderExtendedPrice](@ID int)

--SYNTAX TO CREATE
Returns DEC(10,2)

AS

BEGIN

	declare @total DEC(10,2)
	Set @total =
	(
		SELECT [OrderDetail].[ItemID],[Item].[Name], FORMAT([OrderDetail].[Quantity]*[OrderDetail].[UnitPrice],'$ ###,###.##') AS [Extended Price]
		FROM [Order]
		JOIN [OrderDetail]
			ON [Order].[OrderID] = [OrderDetail].[OrderID]
		JOIN [Item]
			ON [Item].[ItemID]=[OrderDetail].[ItemID]
		WHERE [Order].[OrderID] = @ID
	)

	IF @total is NUll BEGIN

		SET @total = 0
	END

	return @total
	
END