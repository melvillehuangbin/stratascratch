-- select * from oscar_nominees;
SELECT
    COUNT(movie) as n_movies_by_abi
FROM oscar_nominees
WHERE nominee = 'Abigail Breslin'