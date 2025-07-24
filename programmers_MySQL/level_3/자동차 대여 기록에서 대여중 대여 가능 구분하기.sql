SELECT CAR_ID, 
CASE 
    -- 기준 날짜에 대여중인 기록이 하나라도 있으면 '대여중'
    -- MAX() 함수에 Boolean 값이 들어갈 때 하나라도 True가 있으면 1 반환
    WHEN MAX('2022-10-16' BETWEEN START_DATE AND END_DATE) THEN '대여중' 
    ELSE '대여 가능'
END AS AVAILABILITY
FROM CAR_RENTAL_COMPANY_RENTAL_HISTORY
GROUP BY CAR_ID -- 같은 차량에 대한 대여 기록이 여러 개 있을 수 있기 때문
ORDER BY CAR_ID DESC;