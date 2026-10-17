-- 1. Demonstrate 'fn_update_timestamp' trigger
-- Check the current modification date of the athlete:
SELECT Id, FirstName, LastName, LastModifiedDate FROM Athletes WHERE Id = 1;
-- Make an update:
UPDATE Athletes SET LastName = 'Коваленко-Новий' WHERE Id = 1;
-- Check again (LastModifiedDate should update automatically):
SELECT Id, FirstName, LastName, LastModifiedDate FROM Athletes WHERE Id = 1;


-- 2. Demonstrate 'vw_ActiveEvents' view
-- View currently active events:
SELECT * FROM vw_ActiveEvents;


-- 3. Demonstrate 'sp_SoftDeleteEvent' procedure
-- Call the soft delete procedure for event No. 2 (deleted by user with Id = 1):
CALL sp_SoftDeleteEvent(2, 1);
-- Check the active events view again (Event No. 2 should disappear from the list):
SELECT * FROM vw_ActiveEvents;
-- But it physically remains in the database:
SELECT Id, Title, IsDeleted, ModifiedBy FROM Events WHERE Id = 2;


-- 4. Demonstrate 'sp_RegisterAthlete' procedure
-- Register athlete (Id=1) for event (Id=1), action performed by admin (Id=2)
CALL sp_RegisterAthlete(1, 1, 2);
-- Check the registrations view:
SELECT * FROM vw_ActiveRegistrations;


-- 5. Demonstrate 'fn_GetSoldTicketsCount' function
-- Count how many tickets have been sold for event No. 1:
SELECT fn_GetSoldTicketsCount(1) AS SoldTicketsCount;