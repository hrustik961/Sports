-- Automatically update the 'LastModifiedDate' column
CREATE OR REPLACE FUNCTION fn_update_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.LastModifiedDate = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Automatically update the 'LastModifiedDate' column in Events table
CREATE TRIGGER trg_events_update
BEFORE UPDATE ON Events
FOR EACH ROW EXECUTE FUNCTION fn_update_timestamp();

-- Automatically update the 'LastModifiedDate' column in Locations table
CREATE TRIGGER trg_locations_update
BEFORE UPDATE ON Locations
FOR EACH ROW EXECUTE FUNCTION fn_update_timestamp();

-- Automatically update the 'LastModifiedDate' column in Athletes table
CREATE TRIGGER trg_athletes_update
BEFORE UPDATE ON Athletes
FOR EACH ROW EXECUTE FUNCTION fn_update_timestamp();

-- Automatically update the 'LastModifiedDate' column in Registrations table
CREATE TRIGGER trg_registrations_update
BEFORE UPDATE ON Registrations
FOR EACH ROW EXECUTE FUNCTION fn_update_timestamp();

-- Automatically update the 'LastModifiedDate' column in Users table
CREATE TRIGGER trg_users_update
BEFORE UPDATE ON Users
FOR EACH ROW EXECUTE FUNCTION fn_update_timestamp();

-- View for active events excluding soft-deleted ones
CREATE OR REPLACE VIEW vw_ActiveEvents AS
SELECT 
    e.Id AS EventId,
    e.Title AS EventTitle,
    e.EventDate,
    c.Name AS CategoryName,
    l.Name AS LocationName,
    l.Address
FROM Events e
JOIN EventCategories c ON e.CategoryId = c.Id
JOIN Locations l ON e.LocationId = l.Id
WHERE e.IsDeleted = FALSE AND l.IsDeleted = FALSE;

-- View for active athlete registrations
CREATE OR REPLACE VIEW vw_ActiveRegistrations AS
SELECT 
    r.Id AS RegistrationId,
    e.Title AS EventTitle,
    a.FirstName,
    a.LastName,
    r.Status,
    r.RegistrationDate
FROM Registrations r
JOIN Events e ON r.EventId = e.Id
JOIN Athletes a ON r.AthleteId = a.Id
WHERE e.IsDeleted = FALSE AND a.IsDeleted = FALSE;

-- Procedure to soft delete an event and log the modifying user
CREATE OR REPLACE PROCEDURE sp_SoftDeleteEvent(p_EventId INT, p_UserId INT)
LANGUAGE plpgsql AS $$
BEGIN
    UPDATE Events 
    SET IsDeleted = TRUE, ModifiedBy = p_UserId, LastModifiedDate = CURRENT_TIMESTAMP
    WHERE Id = p_EventId;
END;
$$;

-- Procedure to register an athlete for an event with admin tracking
CREATE OR REPLACE PROCEDURE sp_RegisterAthlete(p_EventId INT, p_AthleteId INT, p_UserId INT)
LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO Registrations (EventId, AthleteId, ModifiedBy)
    VALUES (p_EventId, p_AthleteId, p_UserId);
END;
$$;

-- Function to count sold tickets for a specific event
CREATE OR REPLACE FUNCTION fn_GetSoldTicketsCount(p_EventId INT)
RETURNS INT AS $$
DECLARE 
    sold_count INT;
BEGIN
    SELECT COUNT(*) INTO sold_count 
    FROM TicketPurchases tp
    JOIN Tickets t ON tp.TicketId = t.Id
    WHERE t.EventId = p_EventId;
    
    RETURN sold_count;
END;
$$ LANGUAGE plpgsql;