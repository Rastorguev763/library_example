## Для проверки запросов, нужно добавить данные в базу:

```sql
-- Добавление данных в таблицу "Publishers"
INSERT INTO public.Publishers (PublisherName, City)
VALUES ('Издательство 1', 'Город 1'),
       ('Издательство 2', 'Город 2'),
       ('Издательство 3', 'Город 3'),
       ('Издательство 4', 'Город 4'),
       ('Издательство 5', 'Город 5');

-- Добавление данных в таблицу "Books"
INSERT INTO public.Books (Title, Authors, PublicationYear, Pages, Price, Quantity, PublisherID)
VALUES ('Книга 1', 'Автор 1', 2016, 200, 19, 3, 1),
       ('Книга 2', 'Автор 2', 2017, 150, 14, 3, 2),
       ('Книга 3', 'Автор 3', 2018, 300, 24, 3, 3),
       ('Книга 4', 'Автор 4', 2019, 250, 29, 3, 4),
       ('Книга 5', 'Автор 5', 2020, 180, 99, 3, 5);

-- Добавление данных в таблицу "Readers"
INSERT INTO public.Readers (Name, Surname, Patronymic, Address, Phone)
VALUES
    ('Иван', 'Иванов', 'Иванович', 'Москва, ул. Пушкина 10', '+7(111)111-1111'),
    ('Анна', 'Смирнова', 'Сергеевна', 'Санкт-Петербург, пр. Невский 20', '+7(222)222-2222'),
    ('Дмитрий', 'Петров', 'Александрович', 'Екатеринбург, ул. Ленина 30', '+7(333)333-3333'),
    ('Екатерина', 'Козлова', 'Михайловна', 'Новосибирск, пр. Карла Маркса 40', '+7(444)444-4444'),
    ('Максим', 'Лебедев', 'Владимирович', 'Казань, ул. Баумана 50', '+7(555)555-5555');

-- Добавление данных в таблицу "Author"
INSERT INTO public.Author (Name, Surname, Patronymic)
VALUES ('Автор 1', 'Фамилия 1', 'Отчество 1'),
       ('Автор 2', 'Фамилия 2', 'Отчество 2'),
       ('Автор 3', 'Фамилия 3', 'Отчество 3'),
       ('Автор 4', 'Фамилия 4', 'Отчество 4'),
       ('Автор 5', 'Фамилия 5', 'Отчество 5');

-- Добавление связей между авторами и книгами
-- Предположим, что у каждой книги один автор, поэтому просто указываем ID автора для каждой книги
INSERT INTO public.Author_Books (AuthorID, BookCode)
VALUES (1, 1),
       (2, 2),
       (3, 3),
       (4, 4),
       (5, 5);

-- Добавление связей между читателями и книгами
INSERT INTO public.Issuing_Books (ReaderID, BookCode, DateIssue, DateDelivery, DaysUse)
VALUES (1, 1, '2023-07-01', NULL, 14),
       (1, 2, '2023-06-01', NULL, 14),
       (1, 3, '2023-06-26', NULL, 14),
       (1, 4, '2023-06-14', NULL, 14),
       (1, 5, '2023-06-24', '2023-07-04', 14),
       (2, 1, '2023-06-24', '2023-07-04', 14),
       (2, 3, '2023-06-21', '2023-07-04', 14),
       (2, 5, '2023-06-20', '2023-07-04', 14),
       (3, 2, '2023-06-20', '2023-06-29', 14),
       (3, 4, '2023-06-11', NULL, 14),
       (3, 1, '2023-06-14', '2023-06-25', 14),
       (4, 1, '2023-06-25', NULL, 14),
       (4, 3, '2023-06-18', '2023-06-30', 14),
       (5, 3, '2023-07-01', NULL, 14);
```

### Определить, сколько книг прочитал каждый читатель в текущем году. Вывести рейтинг читателей по убыванию.

```sql
SELECT R.Name || ' ' || R.Patronymic|| ' ' || R.Surname  AS FullName, COUNT(*) AS BooksRead
FROM public.Issuing_Books AS IB
JOIN public.Readers AS R ON IB.ReaderID = R.ReaderID
WHERE IB.DateDelivery IS NOT NULL
GROUP BY R.Name, R.Surname, R.Patronymic
ORDER BY BooksRead DESC;
```

### Определить, сколько книг у читателей на руках на текущую дату.

```sql
SELECT R.Name || ' ' || R.Patronymic|| ' ' || R.Surname  AS FullName, COUNT(*) AS BooksRead
FROM public.Issuing_Books AS IB
JOIN public.Readers AS R ON IB.ReaderID = R.ReaderID
WHERE IB.DateDelivery IS NULL
GROUP BY R.Name, R.Surname, R.Patronymic
ORDER BY BooksRead DESC;
```

### Определить читателей, у которых на руках определенная книга.

```sql
SELECT R.Name || ' ' || R.Patronymic|| ' ' || R.Surname  AS FullName, COUNT(*) AS BooksRead
FROM public.Issuing_Books AS IB
JOIN public.Readers AS R ON IB.ReaderID = R.ReaderID
JOIN PUBLIC.Books AS B on IB.BookCode = B.BookCode
WHERE B.Title = 'Книга 1' AND IB.DateDelivery IS NULL
GROUP BY  R.Name, R.Surname, R.Patronymic;
```

### Определите, какие книги на руках читателей.

```sql
SELECT R.Name || ' ' || R.Patronymic|| ' ' || R.Surname  AS FullName, B.Title AS BooksRead
FROM public.Issuing_Books AS IB
JOIN public.Readers AS R ON IB.ReaderID = R.ReaderID
JOIN PUBLIC.Books AS B on IB.BookCode = B.BookCode
WHERE IB.DateDelivery IS NULL
GROUP BY R.Name, R.Surname, R.Patronymic, B.Title;
```

### Вывести количество должников на текущую дату.

```sql
SELECT R.Name || ' ' || R.Patronymic || ' ' || R.Surname AS FullName, B.Title AS BooksRead
FROM public.Issuing_Books AS IB
JOIN public.Readers AS R ON IB.ReaderID = R.ReaderID
JOIN public.Books AS B ON IB.BookCode = B.BookCode
WHERE IB.DateDelivery IS NULL AND IB.DateIssue <= (CURRENT_DATE - CAST(IB.DaysUse || ' DAY' AS INTERVAL))
GROUP BY R.Name, R.Surname, R.Patronymic, B.Title;
```

### Книги какого издательства были самыми востребованными у читателей? Отсортируйте издательства по убыванию востребованности книг.

```sql
SELECT PB.PublisherName AS PublisherName, COUNT(*) AS BooksRead
FROM public.Issuing_Books AS IB
JOIN public.Books AS B ON IB.BookCode = B.BookCode
JOIN public.Publishers AS PB ON PB.PublisherID = B.PublisherID
WHERE IB.DateDelivery IS NOT NULL
GROUP BY PB.PublisherName
ORDER BY BooksRead DESC;
```

### Определить самого издаваемого автора.

```sql
SELECT A.Name, A.Patronymic, A.Surname,  COUNT(*) AS IssuedBooksCount
FROM public.Author A
JOIN public.Author_Books AB ON A.AuthorID = AB.AuthorID
JOIN public.Books B ON AB.BookCode = B.BookCode
JOIN public.Issuing_Books IB ON B.BookCode = IB.BookCode
GROUP BY A.Name, A.Surname, A.Patronymic
ORDER BY IssuedBooksCount DESC;
```

Определить среднее количество прочитанных страниц читателем за день.

```sql
SELECT R.Name || ' ' || R.Patronymic || ' ' || R.Surname AS FullName, B.Title AS BooksRead, B.Pages AS Pages,
       ABS(IB.DateIssue - IB.DateDelivery) AS INTERVAL, Pages / ABS(IB.DateIssue - IB.DateDelivery) AS delta
FROM public.Issuing_Books AS IB
JOIN public.Readers AS R ON IB.ReaderID = R.ReaderID
JOIN PUBLIC.Books AS B ON IB.BookCode = B.BookCode
WHERE IB.DateDelivery IS NOT NULL
GROUP BY R.Name, R.Patronymic, R.Surname, B.Title, B.Pages, (IB.DateIssue - IB.DateDelivery);
```