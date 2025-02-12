CREATE TRIGGER trg_PreventInvoiceForNonExecutedOrders
ON Invoices
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    -- Check if any inserted invoice belongs to a non-executed order
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN Orders o ON i.order_ID = o.order_ID
        WHERE o.order_status <> 'executed'  -- Order is not fully executed
    )
    BEGIN
        -- Rollback the transaction and raise an error
        ROLLBACK TRANSACTION;
        THROW 50000, 'Cannot create an invoice for an order that is not fully executed.', 1;
    END
END;



------------------------------------------------------------------------
CREATE TRIGGER trg_UpdateOrderStatusOnExecution
ON Executions
AFTER INSERT, UPDATE
AS
BEGIN
    UPDATE Orders
    SET order_status = 
        CASE 
            WHEN (SELECT SUM(e.executed_quantity) FROM Executions e WHERE e.order_ID = Orders.order_ID) = Orders.total_quantity
            THEN 'Executed'
            ELSE 'Partially Executed'
        END
    WHERE order_ID IN (SELECT order_ID FROM inserted);
END;

--------------------------------------------------------------------------------

