SELECT *
FROM PLACES
WHERE HOST_ID IN ( -- HOST_ID가 2개 이상 존재하는 그룹에 속한 모든 행을 가져오는 쿼리
    SELECT HOST_ID
    FROM PLACES
    GROUP BY HOST_ID -- 각 HOST_ID별로 행 수가 2개 이상인 HOST_ID만 뽑아냄
    HAVING COUNT(*) >= 2
); 