-- 비트연산자 활용

SELECT count(ID) AS COUNT
FROM ECOLI_DATA
WHERE (GENOTYPE & 2) = 0
  AND ((GENOTYPE & 1) != 0
       OR (GENOTYPE & 4) != 0);  