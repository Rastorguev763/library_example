CREATE TABLE Readers (
  ReaderID INT PRIMARY KEY,
  Name VARCHAR(255),
  Surname VARCHAR(255),
  Patronymic VARCHAR(255),
  Address VARCHAR(255),
  Phone VARCHAR(20),
  BookCode INT,
  FOREIGN KEY (BookCode) REFERENCES Books (BookCode)
);

CREATE TABLE Books (
  BookCode INT PRIMARY KEY,
  Title VARCHAR(255),
  Authors VARCHAR(255),
  PublicationYear INT,
  Pages INT,
  Price DECIMAL(10, 2),
  Quantity INT,
  PublisherID VARCHAR(255),
  FOREIGN KEY (PublisherID) REFERENCES Publishers (PublisherID)
);

CREATE TABLE Publishers (
  PublisherID VARCHAR(255) PRIMARY KEY,
  PublisherName VARCHAR(255),
  City VARCHAR(255)
);
