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