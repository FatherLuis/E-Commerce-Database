




CREATE TABLE [Person]
(
	[PersonID] INT IDENTITY(1,1),
	[FirstName] NVARCHAR(50) NOT NULL,
	[LastName] NVARCHAR(50) NOT NULL,
	[isActive] BIT NOT NULL,

	CONSTRAINT [PK_Person] PRIMARY KEY(PersonID)
)

CREATE TABLE [Employee]
(
	[PersonID] INT NOT NULL,
	[EmployeeID] INT NOT NULL,
	[JobTitle] NVARCHAR(50) NOT NULL,
	[HireDate] DATE NOT NULL,
	[FireDate] DATE NULL,
	[isActive] BIT NOT NULL,

	CONSTRAINT [PK_Employee_Person] PRIMARY KEY(EmployeeID),
	CONSTRAINT [FK_Employee_Person] FOREIGN KEY(PersonID) REFERENCES[Person](PersonID)
		ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT [UQ_Employee_Person] UNIQUE(PersonID)
)

CREATE TABLE [State]
(
	[StateID] INT NOT NULL,
	[Name] NVARCHAR(20) NOT NULL,
	[Abbev] CHAR(2) NOT NULL,

	CONSTRAINT [StatePK] PRIMARY KEY([StateID])
)

-------------------------------------------------------------

CREATE TABLE [Address]
(
	[AddressID] INT NOT NULL,
	[AddressLine] NVARCHAR(55) NOT NULL,
	[City] NVARCHAR(50) NOT NULL,
	[StateID] INT NOT NULL,
	[PostalCode] INT NOT NULL,
	[isActive] BIT NOT NULL,

	CONSTRAINT [AddressPK] PRIMARY KEY([AddressID]),
	CONSTRAINT [FK_Address_State] FOREIGN KEY(StateID) REFERENCES[State](StateID)
		ON UPDATE NO ACTION ON DELETE NO ACTION
)



CREATE TABLE [CreditCard]
(
	[CreditCardID] INT NOT NULL,
	[CardType] NVARCHAR(30) NOT NULL,
	[CardNumber] INT NOT NULL,
	[ExpMonth] INT NOT NULL,
	[ExpYear] INT NOT NULL,
	[isActive] BIT NOT NULL,

	CONSTRAINT [CreditCardPK] PRIMARY KEY([CreditCardID]),
	CONSTRAINT [ExpMonthCK] CHECK ([ExpMonth] > 0 AND [ExpMonth] < 13),
	CONSTRAINT [ExPYearCK] CHECK ([ExpYear] > 0)
)

-------------------------------------------------------------

CREATE TABLE [Payment]
(
	[PersonID] INT NOT NULL,
	[CreditCardID] INT NOT NULL

	CONSTRAINT [PK_Payment] PRIMARY KEY(PersonID,CreditCardID),
	CONSTRAINT [FK_Payment_Person] FOREIGN KEY(PersonID) REFERENCES[Person](PersonID)
		ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT [FK_Payment_CreditCard] FOREIGN KEY(CreditCardID) REFERENCES[CreditCard](CreditCardID)
		ON UPDATE NO ACTION ON DELETE NO ACTION
)

-------------------------------------------------------------

CREATE TABLE [Customer]
(
	[PersonID] INT NOT NULL,
	[CustomerID] INT IDENTITY(1,1),
	[isActive] BIT NOT NULL

	CONSTRAINT [CustomerPK] PRIMARY KEY(CustomerID),
	CONSTRAINT [FK_Customer_Person] FOREIGN KEY(PersonID) REFERENCES[Person](PersonID)
)

CREATE TABLE [PersonAddress]
(
	[PersonID] INT NOT NULL,
	[AddressID] INT NOT NULL,

	CONSTRAINT [PK_PersonAddress] PRIMARY KEY(PersonID,AddressID),
	CONSTRAINT [FK_PersonAddress_Person] FOREIGN KEY(PersonID) REFERENCES[Person](PersonID)
		ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT [FK_PersonAddress_Address] FOREIGN KEY(AddressID) REFERENCES[Address](AddressID)
		ON UPDATE NO ACTION ON DELETE NO ACTION
)

-------------------------------------------------------------

CREATE TABLE [Category]
(
	[CategoryID] INT NOT NULL,
	[Name] NVARCHAR(70) NOT NULL,

	CONSTRAINT [CategoryPK] PRIMARY KEY(CategoryID)

)

-------------------------------------------------------------

CREATE TABLE [Item]
(
	[ItemID] INT NOT NULL,
	[Name] NVARCHAR(70) NOT NULL,
	[ProductNumber] NVARCHAR(20) NOT NULL,
	[CategoryID] INT NOT NULL,
	[isActive] BIT NOT NULL,

	CONSTRAINT [ItemPK] PRIMARY KEY(ItemID),
	CONSTRAINT [FK_Item_Category] FOREIGN KEY(CategoryID) REFERENCES[Category](CategoryID)
		ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT UQ_ProductNumber UNIQUE(ProductNumber)
)

-------------------------------------------------------------

CREATE TABLE [Inventory]
(
	[ItemID] INT NOT NULL,
	[Quantity] INT NOT NULL,
	[UnitPrice] INT NOT NULL,
	[isActive] BIT NOT NULL,

	CONSTRAINT [InventoryPK] PRIMARY KEY(ItemID),
	CONSTRAINT [FK_Inventory_Item] FOREIGN KEY(ItemID) REFERENCES[Item]([ItemID])
		ON UPDATE NO ACTION ON DELETE NO ACTION	
)

-------------------------------------------------------------

CREATE TABLE [Supplier]
(
	[SupplierID] INT NOT NULL,
	[CompanyName] NVARCHAR(50) NOT NULL,
	[AddressID] INT NOT NULL,
	[isActive] BIT NOT NULL,

	CONSTRAINT [SupplierPK] PRIMARY KEY(SupplierID),
	CONSTRAINT [FK_Supplier_Address] FOREIGN KEY(AddressID) REFERENCES[Address]([AddressID])
		ON UPDATE NO ACTION ON DELETE NO ACTION	
)

-------------------------------------------------------------

CREATE TABLE [SupplierProduct]
(
	[SupplierID] INT NOT NULL,
	[ItemID] INT NOT NULL,
	[UnitPrice] DEC NOT NULL,
	[isActive] BIT NOT NULL,

	CONSTRAINT [SupplierProductPK] PRIMARY KEY(SupplierID,ItemID),
	CONSTRAINT [FK_SupplierProduct_Item] FOREIGN KEY(ItemID) REFERENCES[Item]([ItemID])
		ON UPDATE NO ACTION ON DELETE NO ACTION,	
	CONSTRAINT [FK_SupplierProduct_Supplier] FOREIGN KEY(SupplierID) REFERENCES[Supplier]([SupplierID])
		ON UPDATE NO ACTION ON DELETE NO ACTION	
)

-------------------------------------------------------------


CREATE TABLE [InvoiceLineItem]
(
	[InvoiceCartID] INT NOT NULL,
	[EmployeeID] INT NOT NULL,
	[BillAddress] INT NOT NULL,
	[ShipAddress] INT NOT NULL,
	[LastModified] DATE NOT NULL,
	[Subtotal] DEC NOT NULL,
	[TaxAmount] DEC NOT NULL,
	[Fees] DEC NOT NULL,
	[Total] DEC NOT NULL,
	[isActive] BIT NOT NULL,

	CONSTRAINT [InvoiceLineItemPK] PRIMARY KEY(InvoiceCartID),
	CONSTRAINT [FK_InvoiceLineItem_Employee] FOREIGN KEY(EmployeeID) REFERENCES[Employee](EmployeeID)
		ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT [FK_InvoiceLineItem_Address_Bill] FOREIGN KEY(BillAddress) REFERENCES[Address](AddressID)
		ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT [FK_InvoiceLineItem_Address_Ship] FOREIGN KEY(ShipAddress) REFERENCES[Address](AddressID)
		ON UPDATE NO ACTION ON DELETE NO ACTION
)

-------------------------------------------------------------

CREATE TABLE [InvoiceLineItemDetail]
(
	[InvoiceCartDetailID] INT NOT NULL,
	[InvoiceCartID] INT NOT NULL,
	[ItemID] INT NOT NULL,
	[SupplierID] INT NOT NULL,
	[Quantity] INT NOT NULL,
	[UnitPrice] INT NOT NULL,
	[isActive] BIT NOT NULL,

	CONSTRAINT [InvoiceLineItemDetailPK] PRIMARY KEY(InvoiceCartDetailID),
	CONSTRAINT [FK_InvoiceLineItemDetail_InvoiceCart] FOREIGN KEY(InvoiceCartID) REFERENCES[InvoiceLineItem](InvoiceCartID)
		ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT [FK_InvoiceLineItemDetail_Item] FOREIGN KEY(ItemID) REFERENCES[Item](ItemID)
		ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT [FK_InvoiceLineItemDetail_Supplier] FOREIGN KEY(SupplierID) REFERENCES[Supplier](SupplierID)
		ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT UQ_InvoiceCart UNIQUE(InvoiceCartID,ItemID)
)

-------------------------------------------------------------

CREATE TABLE [Invoice]
(
	[InvoiceID] INT NOT NULL,
	[EmployeeID] INT NOT NULL,
	[BillAddress] INT NOT NULL,
	[ShipAddress] INT NOT NULL,
	[Date] DATE NOT NULL,
	[TaxAmount] INT NOT NULL,
	[Fees] DEC NOT NULL,
	[Subtotal] DEC NOT NULL,
	[Total] DEC NOT NULL,
	[isActive] BIT NOT NULL,

	CONSTRAINT [InvoicePK] PRIMARY KEY(InvoiceID),
	CONSTRAINT [FK_Invoice_Employee] FOREIGN KEY(EmployeeID) REFERENCES[Employee](EmployeeID)
		ON UPDATE NO ACTION ON DELETE NO ACTION,	
	CONSTRAINT [FK_Invoice_Address_Bill] FOREIGN KEY(BillAddress) REFERENCES[Address](AddressID)
		ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT [FK_Invoice_Address_Ship] FOREIGN KEY(ShipAddress) REFERENCES[Address](AddressID)
		ON UPDATE NO ACTION ON DELETE NO ACTION
)

-------------------------------------------------------------

CREATE TABLE [InvoiceDetail]
(
	[InvoiceDetailID] int NOT NULL,
	[InvoiceID] INT NOT NULL,
	[ItemID] INT NOT NULL,	
	[SupplierID] INT NOT NULL,
	[Quantity] INT NOT NULL,
	[UnitPrice] INT NOT NULL,
	[isActive] BIT NOT NULL,

	CONSTRAINT [InvoiceDetailPK] PRIMARY KEY(InvoiceDetailID),
	CONSTRAINT [FK_InvoiceDetail_Invoice] FOREIGN KEY(InvoiceID) REFERENCES[Invoice](InvoiceID)
		ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT [FK_InvoiceDetail_Item] FOREIGN KEY(ItemID) REFERENCES[Item](ItemID)
		ON UPDATE NO ACTION ON DELETE NO ACTION,	
	CONSTRAINT [FK_InvoiceDetail_Supplier] FOREIGN KEY(SupplierID) REFERENCES[Supplier](SupplierID)
		ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT UQ_Invoice_Item UNIQUE(InvoiceID,ItemID)
)

-------------------------------------------------------------

CREATE TABLE [OrderLineItem]
(
	[OrderCartID] INT NOT NULL,
	[CustomerID] INT NOT NULL,
	[LastModified] DATE NOT NULL,
	[BillAddress] INT NOT NULL,
	[ShipAddress] INT NOT NULL,
	[SubTotal] DEC NOT NULL,
	[TaxAmount] DEC NOT NULL,
	[Fees] DEC NOT NULL,
	[Total] DEC NOT NULL,
	[isActive] BIT NOT NULL,

	CONSTRAINT [OrderLineItemPK] PRIMARY KEY(OrderCartID),
	CONSTRAINT [FK_OrderLineItem_Customer] FOREIGN KEY(CustomerID) REFERENCES[Customer](CustomerID)
		ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT [FK_OrderLineItem_Address_Bill] FOREIGN KEY(BillAddress) REFERENCES[Address](AddressID)
		ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT [FK_OrderLineItem_Address_Ship] FOREIGN KEY(ShipAddress) REFERENCES[Address](AddressID)
		ON UPDATE NO ACTION ON DELETE NO ACTION
)

-------------------------------------------------------------

CREATE TABLE [OrderLineItemDetail]
(
	[OrderCartDetailID] INT NOT NULL,
	[OrderCartID] INT NOT NULL,
	[ItemID] INT NOT NULL,
	[Quantity] INT NOT NULL,
	[UnitPrice] INT NOT NULL,
	[isActive] BIT NOT NULL,

	CONSTRAINT [OrderCartDetailPK] PRIMARY KEY(OrderCartDetailID),
	CONSTRAINT [FK_OrderCartDetail_OrderCart] FOREIGN KEY(OrderCartID) REFERENCES[OrderLineItem](OrderCartID)
		ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT [FK_OrderCartDetail_Item] FOREIGN KEY(ItemID) REFERENCES[Item](ItemID)
		ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT UQ_OrderCart_Item UNIQUE(OrderCartID,ItemID)
		
)

-------------------------------------------------------------

CREATE TABLE [FeeAreas]
(
	[StateID] INT NOT NULL,
	[TaxCharge] DEC NOT NULL,
	[ShippingFee] DEC NOT NULL,

	CONSTRAINT [State_PK] PRIMARY KEY(StateID),
	CONSTRAINT [FK_FeeAreas_State] FOREIGN KEY(StateID) REFERENCES[State](StateID)
		ON UPDATE NO ACTION ON DELETE NO ACTION
)

-------------------------------------------------------------

CREATE TABLE [Order]
(
	[OrderID] INT NOT NULL,
	[CustomerID] INT NOT NULL,
	[Date] DATE NOT NULL,
	[BillAddress] INT NOT NULL,
	[ShipAddress] INT NOT NULL,
	[Subtotal] DEC NOT NULL,
	[TaxAmount] DEC NOT NULL,
	[Fees] DEC NOT NULL,
	[Total] DEC NOT NULL,
	[isActive] BIT NOT NULL,

	CONSTRAINT [OrderPK] PRIMARY KEY(OrderID),
	CONSTRAINT [FK_Order_Customer] FOREIGN KEY(CustomerID) REFERENCES[Customer](CustomerID)
		ON UPDATE NO ACTION ON DELETE NO ACTION,	
	CONSTRAINT [FK_Order_Address_Bill] FOREIGN KEY(BillAddress) REFERENCES[Address](AddressID)
		ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT [FK_Order_Address_Ship] FOREIGN KEY(ShipAddress) REFERENCES[Address](AddressID)
		ON UPDATE NO ACTION ON DELETE NO ACTION
)

-------------------------------------------------------------

CREATE TABLE [OrderDetail]
(
	[OrderDetailID] INT NOT NULL,
	[OrderID] INT NOT NULL,
	[ItemID] INT NOT NULL,
	[Quantity] INT NOT NULL,
	[UnitPrice] INT NOT NULL,
	[isActive] BIT NOT NULL,

	CONSTRAINT [OrderDetailPK] PRIMARY KEY(OrderDetailID),
	CONSTRAINT [FK_OrderDetail_Order] FOREIGN KEY(OrderID) REFERENCES[Order](OrderID)
		ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT [FK_OrderDetail_Item] FOREIGN KEY(ItemID) REFERENCES[Item](ItemID)
		ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT UQ_Order_Item UNIQUE(OrderID,ItemID)
)

-------------------------------------------------------------