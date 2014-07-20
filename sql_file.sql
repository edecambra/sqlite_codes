 --problem 1
 --(a) select: Write a query that is equivalent to the following relational algebra expression. σ10398_txt_earn(frequency)
SELECT count(*) FROM( 
SELECT * FROM frequency
WHERE docid = "10398_txt_earn"
);

--problem 2
--(b) select project: Write a SQL statement that is equivalent to the following relational algebra expression. πterm(σdocid=10398_txt_earn and count=1(frequency))
SELECT count(*) FROM (  
SELECT term 
FROM frequency
WHERE docid = "10398_txt_earn" AND
WHERE count = 1
);

--problem 3
--(c) union: Write a SQL statement that is equivalent to the following relational algebra expression. (Hint: you can use the UNION keyword in SQL)
--πterm(σdocid=10398_txt_earn and count=1(frequency)) U πterm(σdocid=925_txt_trade and count=1(frequency))
SELECT count(*) FROM (  
SELECT * FROM frequency 
WHERE docid = "10398_txt_earn" 
AND count = 1
UNION 
SELECT term FROM frequency 
WHERE docid = "925_txt_trade" 
AND count = 1

);

--Problem 4
--(d) count: Write a SQL statement to count the number of documents containing the word "parliament"
SELECT count(*) FROM (   
SELECT * FROM frequency 
WHERE term = "parliament" 
);

 --problem 5
-- (e) big documents Write a SQL statement to find all documents that have more than 300 total terms, including duplicate terms. (Hint: You can use the HAVING clause, or you can use a nested query. Another hint: Remember that the count column contains the term frequencies, and you want to consider duplicates.) (docid, term_count)
SELECT count(*) FROM( 
SELECT * FROM ( 
SELECT sum(count) as total_terms FROM frequency
GROUP BY docid)
WHERE total_terms > 300
);

--problem 6
--(f) two words: Write a SQL statement to count the number of unique documents that contain both the word 'transactions' and the word 'world'.  
SELECT count(*) FROM( 
SELECT * 
FROM (
SELECT * FROM frequency
WHERE term = "transaction") AS t, (
SELECT * FROM frequency
WHERE term = "world") AS w
WHERE t.docid = w.docid
);

--problem 7
--The matrix A and matrix B are both square matrices with 5 rows and 5 columns each.
--(g) multiply: Express A X B as a SQL query, referring to the class lecture for hints.
--A(row_num, col_num, value)
--B(row_num, col_num, value)
SELECT value FROM(   
SELECT A.row_num, B.col_num, SUM(A.value * B.value) AS value
FROM A, B
WHERE A.col_num = B.row_num
GROUP BY A.row_num, b.col_num)
WHERE row_num = 2 AND col_num = 3;

--problem 8
--(h) similarity matrix: Write a query to compute the similarity matrix DDT. (Hint: The transpose is trivial -- just join on columns to columns instead of columns to rows.) The query could take some time to run if you compute the entire result. But notice that you don't need to compute the similarity of both (doc1, doc2) and (doc2, doc1) -- they are the same, since similarity is symmetric. If you wish, you can avoid this wasted work by adding a condition of the form a.docid < b.docid to your query. (But the query still won't return immediately if you try to compute every result -- don't expect otherwise.)
SELECT sim FROM (  
SELECT A.docid AS doc1, B.docid AS doc2, SUM(A.count*B.count) AS sim
FROM (
SELECT * FROM frequency WHERE docid = "10080_txt_crude") AS A, (
SELECT * FROM frequency WHERE docid = "17035_txt_earn") AS B
WHERE A.term = B.term
GROUP BY A.docid, B.docid);
   
--problem 9
--(i) keyword search: Find the best matching document to the keyword query "washington taxes treasury". You can add this set of keywords to the document corpus with a union of scalar queries. Then, compute the similarity matrix again, but filter for only similarities involving the "query document": docid = 'q'. Consider creating a view of this new corpus to simplify things.   
CREATE VIEW query AS
SELECT * FROM frequency
UNION
SELECT 'q' as docid, 'washington' as term, 1 as count 
UNION
SELECT 'q' as docid, 'taxes' as term, 1 as count
UNION 
SELECT 'q' as docid, 'treasury' as term, 1 as count;
 
 SELECT sim FROM (  
SELECT A.docid AS doc, SUM(A.count*B.count) AS sim
FROM query AS A, (
SELECT * FROM query WHERE docid = "q") AS B
WHERE A.term = B.term
GROUP BY A.docid, B.docid)
Order by sim
LIMIT 1;

