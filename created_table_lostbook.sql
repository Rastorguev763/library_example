CREATE TABLE public.LostBooks (
  LostBooksID SERIAL PRIMARY KEY,
  DateLost DATE,
  BookCode INT,
  ReaderID INT,
  FOREIGN KEY (BookCode) REFERENCES public.Books (BookCode),
  FOREIGN KEY (ReaderID) REFERENCES public.Readers (ReaderID)
);
