-- Creating the Users table
CREATE TABLE Users (
    Id SERIAL PRIMARY KEY,
    Username VARCHAR(50) NOT NULL UNIQUE,
    Email VARCHAR(100) NOT NULL UNIQUE,
    IsDeleted BOOLEAN DEFAULT FALSE, 
    LastModifiedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ModifiedBy INT 
);

-- Creating the Roles table
CREATE TABLE Roles (
    Id SERIAL PRIMARY KEY,
    Name VARCHAR(50) NOT NULL UNIQUE
);

-- Creating the UserRoles table
CREATE TABLE UserRoles (
    Id SERIAL PRIMARY KEY,
    UserId INT NOT NULL REFERENCES Users(Id),
    RoleId INT NOT NULL REFERENCES Roles(Id)
);

-- Creating the EventCategories table
CREATE TABLE EventCategories (
    Id SERIAL PRIMARY KEY,
    Name VARCHAR(100) NOT NULL
);

-- Creating the Locations table
CREATE TABLE Locations (
    Id SERIAL PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Address VARCHAR(255) NOT NULL,
    IsDeleted BOOLEAN DEFAULT FALSE,
    LastModifiedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ModifiedBy INT REFERENCES Users(Id)
);


-- Creating the Events table
CREATE TABLE Events (
    Id SERIAL PRIMARY KEY,
    CategoryId INT NOT NULL REFERENCES EventCategories(Id),
    LocationId INT NOT NULL REFERENCES Locations(Id),
    Title VARCHAR(255) NOT NULL,
    Description TEXT,
    EventDate TIMESTAMP NOT NULL,
    IsDeleted BOOLEAN DEFAULT FALSE,
    LastModifiedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ModifiedBy INT REFERENCES Users(Id)
);

-- Creating the Athletes table
CREATE TABLE Athletes (
    Id SERIAL PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    DateOfBirth DATE,
    IsDeleted BOOLEAN DEFAULT FALSE,
    LastModifiedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ModifiedBy INT REFERENCES Users(Id)
);

-- Creating the Teams table
CREATE TABLE Teams (
    Id SERIAL PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    IsDeleted BOOLEAN DEFAULT FALSE,
    LastModifiedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ModifiedBy INT REFERENCES Users(Id)
);

-- Creating the TeamMembers table
CREATE TABLE TeamMembers (
    Id SERIAL PRIMARY KEY,
    TeamId INT NOT NULL REFERENCES Teams(Id),
    AthleteId INT NOT NULL REFERENCES Athletes(Id)
);

-- Creating the Registrations table
CREATE TABLE Registrations (
    Id SERIAL PRIMARY KEY,
    EventId INT NOT NULL REFERENCES Events(Id),
    AthleteId INT NOT NULL REFERENCES Athletes(Id),
    RegistrationDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Status VARCHAR(20) DEFAULT 'Pending',
    LastModifiedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ModifiedBy INT REFERENCES Users(Id)
);

-- Creating the Results table
CREATE TABLE Results (
    Id SERIAL PRIMARY KEY,
    RegistrationId INT NOT NULL REFERENCES Registrations(Id),
    Score DECIMAL(10, 2),
    Position INT,
    LastModifiedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ModifiedBy INT REFERENCES Users(Id)
);

-- Creating the Sponsors table
CREATE TABLE Sponsors (
    Id SERIAL PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    ContactInfo VARCHAR(255),
    IsDeleted BOOLEAN DEFAULT FALSE,
    LastModifiedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ModifiedBy INT REFERENCES Users(Id)
);

-- Creating the EventSponsors table
CREATE TABLE EventSponsors (
    Id SERIAL PRIMARY KEY,
    EventId INT NOT NULL REFERENCES Events(Id),
    SponsorId INT NOT NULL REFERENCES Sponsors(Id),
    Amount DECIMAL(12, 2) NOT NULL
);

-- Creating the Tickets table
CREATE TABLE Tickets (
    Id SERIAL PRIMARY KEY,
    EventId INT NOT NULL REFERENCES Events(Id),
    Type VARCHAR(50) NOT NULL,
    Price DECIMAL(10, 2) NOT NULL,
    TotalQuantity INT NOT NULL
);

-- Creating the TicketPurchases table
CREATE TABLE TicketPurchases (
    Id SERIAL PRIMARY KEY,
    TicketId INT NOT NULL REFERENCES Tickets(Id),
    BuyerName VARCHAR(100) NOT NULL,
    BuyerEmail VARCHAR(100) NOT NULL,
    PurchaseDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

ALTER TABLE Users ADD CONSTRAINT fk_users_modifiedby FOREIGN KEY (ModifiedBy) REFERENCES Users(Id);

-- B-tree index
CREATE INDEX idx_events_eventdate ON Events USING btree(EventDate);

-- Hash index
CREATE INDEX idx_users_email ON Users USING hash(Email);