SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create Function [getOrderSubtotal](@ID int)

--SYNTAX TO CREATE
Returns float

AS

BEGIN

	declare @total float
	Set @total =
	(
		SELECT SUM([Quantity] * [UnitPrice]) AS [Total]
		FROM [OrderDetail]
		WHERE [OrderDetailsID] = @ID
	)

	IF @total is NUll BEGIN

		SET @total = 0
	END

	return @total
	
END




