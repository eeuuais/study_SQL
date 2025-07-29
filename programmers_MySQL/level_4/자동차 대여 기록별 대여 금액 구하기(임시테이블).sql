/* 
RentalData와 DiscountRate를 MatchedDiscount 에서 조인하여
대여 기간에 맞는 할인율을 찾아 최대값을 구하고
그 결과를 기반으로 최종 SELECT문에서 대여 금액(FEE)을 계산
*/

WITH RentalData AS (
    SELECT
        H.HISTORY_ID,
        C.DAILY_FEE,
        DATEDIFF(H.END_DATE, H.START_DATE) + 1 AS RENT_DAYS -- +1하여 포함일수 맞춤
    FROM CAR_RENTAL_COMPANY_RENTAL_HISTORY H
    JOIN CAR_RENTAL_COMPANY_CAR C ON H.CAR_ID = C.CAR_ID
    WHERE C.CAR_TYPE = '트럭'
), -- CTE(임시테이블) 트럭만 골라서 대여기록별로 HISTORY_ID, DAILY_FEE, RENT_DAYS 계산

DiscountRate AS (
    SELECT
        PLAN_ID,
        CAR_TYPE,
        DURATION_TYPE,
        DISCOUNT_RATE,
        CASE -- 문자열을 숫자기준으로 바꾸기
            WHEN DURATION_TYPE = '7일 이상' THEN 7
            WHEN DURATION_TYPE = '30일 이상' THEN 30
            WHEN DURATION_TYPE = '90일 이상' THEN 90
            ELSE 0
        END AS DURATION_MIN -- 해당 숫자를 기준으로 할인 적용여부 판단할 수 있도록 함
    FROM CAR_RENTAL_COMPANY_DISCOUNT_PLAN
    WHERE CAR_TYPE = '트럭' -- 트럭에 해당하는 할인 정책 불러오기
),

MatchedDiscount AS (
    SELECT
        R.HISTORY_ID,
        R.DAILY_FEE,
        R.RENT_DAYS,
        COALESCE(MAX(D.DISCOUNT_RATE), 0) AS MAX_DISCOUNT_RATE -- 가장 할인율 높은 정책 하나를 선택
    FROM RentalData R
    LEFT JOIN DiscountRate D ON R.RENT_DAYS >= D.DURATION_MIN
    GROUP BY R.HISTORY_ID, R.DAILY_FEE, R.RENT_DAYS
) -- 임시테이블3 : RentalData, DiscountRate 조인하여 대여기간이 할인정책의 DURATION_MIN 이상인 정책을 매칭

SELECT
    HISTORY_ID,
    FLOOR(DAILY_FEE * RENT_DAYS * (1 - MAX_DISCOUNT_RATE / 100)) AS FEE
FROM MatchedDiscount
ORDER BY FEE DESC, HISTORY_ID DESC;
