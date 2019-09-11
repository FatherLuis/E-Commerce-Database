SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create Function [getOrderShippingAmount](@ID int)

--SYNTAX TO CREATE
Returns DEC(10,2)

AS

BEGIN

	declare @total DEC(10,2)
	Set @total =
	(
		SELECT FA.[ShippingFee]
		FROM [FeeAreas] AS FA
		JOIN [Address] 
			ON [Address].[stateID] = [FA].[StateID]
		JOIN [Order]
			ON [Address].[AddressID] = [Order].[ShipAddress]
		WHERE [Order].[OrderID] = @ID
	)

	IF @total is NUll BEGIN

		SET @total = 0
	END

	return @total
	
END
