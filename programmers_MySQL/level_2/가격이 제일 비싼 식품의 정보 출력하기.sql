SELECT *
FROM FOOD_PRODUCT
ORDER BY PRICE DESC
LIMIT 1

-- 오답노트 : max(price)는 집계 함수. 집계 함수를 사용할 때는 GROUP BY를 쓰거나, 안 쓰면 집계함수가 아닌 컬럼들은 결과에 포함할 수 없음.
-- SELECT PRODUCT_ID, PRODUCT_NAME, PRODUCT_CD, CATEGORY, MAX(PRICE)
-- FROM FOOD_PRODUCT