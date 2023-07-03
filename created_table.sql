CREATE TABLE public.Publishers (
  PublisherID SERIAL PRIMARY KEY,
  PublisherName VARCHAR(255),
  City VARCHAR(255)
);

CREATE TABLE public.Books (
  BookCode SERIAL PRIMARY KEY,
  Title VARCHAR(255),
  Authors VARCHAR(255),
  PublicationYear INT,
  Pages INT,
  Price DECIMAL(10, 2),
  Quantity INT,
  PublisherID INT,
  FOREIGN KEY (PublisherID) REFERENCES public.Publishers (PublisherID)
);

CREATE TABLE public.Readers (
  ReaderID SERIAL PRIMARY KEY,
  Name VARCHAR(255),
  Surname VARCHAR(255),
  Patronymic VARCHAR(255),
  Address VARCHAR(255),
  Phone VARCHAR(20),
);

CREATE TABLE public.Author (
  AuthorID SERIAL PRIMARY KEY,
  Name VARCHAR(255),
  Surname VARCHAR(255),
  Patronymic VARCHAR(255),
);

CREATE TABLE public.Author_Books (
FOREIGN KEY (AuthorID) REFERENCES public.Author (AuthorID),
FOREIGN KEY (BookCode) REFERENCES public.Books (BookCode)
);

CREATE TABLE public.Issuing_Books (
FOREIGN KEY (ReaderID) REFERENCES public.Readers (ReaderID),
FOREIGN KEY (BookCode) REFERENCES public.Books (BookCode)
);