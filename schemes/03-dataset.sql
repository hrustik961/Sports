-- Inserting into Users table
INSERT INTO Users (Username, Email) VALUES
('admin_ivan', 'ivan.admin@example.com'),
('org_anna', 'anna.org@example.com'),
('athlete_petro', 'petro.run@example.com');

-- Inserting into Roles table
INSERT INTO Roles (Name) VALUES
('Administrator'),
('Organizer'),
('Athlete');

-- Inserting into UserRoles table
INSERT INTO UserRoles (UserId, RoleId) VALUES
(1, 1), -- admin_ivan -> Administrator
(2, 2), -- org_anna -> Organizer
(3, 3); -- athlete_petro -> Athlete

-- Inserting into EventCategories table
INSERT INTO EventCategories (Name) VALUES
('Марафон'), 
('Футбольний матч'), 
('Плавання');

-- Inserting into Locations table
INSERT INTO Locations (Name, Address, ModifiedBy) VALUES
('Олімпійський стадіон', 'Київ, вул. Велика Васильківська 55', 1),
('Басейн Акварена', 'Львів, вул. Спортивна 1', 1),
('Центральний Парк', 'Рівне, вул. Паркова 1', 1);

-- Inserting into Events table
INSERT INTO Events (CategoryId, LocationId, Title, Description, EventDate, ModifiedBy) VALUES
(1, 3, 'Весняний Марафон 2024', 'Щорічний забіг на 42 км', '2024-05-15 09:00:00', 2),
(2, 1, 'Благодійний Матч', 'Збір коштів для дітей', '2024-06-20 18:00:00', 2);

-- Inserting into Athletes table
INSERT INTO Athletes (FirstName, LastName, DateOfBirth, ModifiedBy) VALUES
('Петро', 'Коваленко', '1995-04-12', 1),
('Марія', 'Шевченко', '1998-08-23', 1),
('Олег', 'Ткачук', '2000-01-15', 1);

-- Inserting into Teams table
INSERT INTO Teams (Name, ModifiedBy) VALUES
('Динамо', 2), 
('Швидкі Ноги', 2);

-- Inserting into TeamMembers table
INSERT INTO TeamMembers (TeamId, AthleteId) VALUES
(1, 3), 
(2, 1), 
(2, 2);

-- Inserting into Registrations table
INSERT INTO Registrations (EventId, AthleteId, Status, ModifiedBy) VALUES
(1, 1, 'Confirmed', 2),
(1, 2, 'Confirmed', 2),
(2, 3, 'Pending', 2);

-- Inserting into Results table
INSERT INTO Results (RegistrationId, Score, Position, ModifiedBy) VALUES
(1, 120.5, 1, 1),
(2, 135.0, 2, 1);

-- Inserting into Sponsors table
INSERT INTO Sponsors (Name, ContactInfo, ModifiedBy) VALUES
('СпортМайстер', 'contact@sportmaster.ua', 1),
('Енерджі Дрінк', 'info@energy.com', 1);

-- Inserting into EventSponsors table
INSERT INTO EventSponsors (EventId, SponsorId, Amount) VALUES
(1, 1, 50000.00),
(1, 2, 25000.00),
(2, 1, 10000.00);

-- Inserting into Tickets table
INSERT INTO Tickets (EventId, Type, Price, TotalQuantity) VALUES
(1, 'Стандарт', 500.00, 1000),
(1, 'VIP', 1500.00, 100),
(2, 'Вхідний', 200.00, 5000);

-- Inserting into TicketPurchases table
INSERT INTO TicketPurchases (TicketId, BuyerName, BuyerEmail) VALUES
(1, 'Ігор Мельник', 'i.melnyk@example.com'),
(2, 'Олена Бойко', 'o.boyko@example.com'),
(3, 'Тарас Грицай', 't.grytsay@example.com');