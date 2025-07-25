-- 문제 조건 : 0시부터 23시까지 각 시간대별로 출력하기
-- 아래처럼 하면 COUNT가 0인 시간이 누락됨
SELECT HOUR(DATETIME)HOUR, COUNT(ANIMAL_ID)
FROM ANIMAL_OUTS
GROUP BY HOUR(DATETIME)
ORDER BY HOUR;



-- 풀이1. MySQL에서는 @변수 형식으로 세션 변수 사용 가능
SET @HOUR := -1; -- 변수선언 : 초기값을 -1로 설정

SELECT (@HOUR := @HOUR + 1) as HOUR, -- @hour의 값에 1씩 증가시키면서 SELECT 문 전체를 실행
    (SELECT COUNT(*) 
     FROM ANIMAL_OUTS 
     WHERE HOUR(DATETIME) = @HOUR) as COUNT
FROM ANIMAL_OUTS
WHERE @HOUR < 23




-- 풀이2. RECURSIVE 활용
-- hours 임시 테이블을 recursive하게 생성
WITH RECURSIVE hours AS (
  SELECT 0 AS hour -- 시작 값으로 0을 갖는 행을 생성
  UNION ALL
  SELECT hour + 1 FROM hours WHERE hour < 23 -- 기존 생성한 hours 테이블에서 hour 값에 1을 더해 새 행을 만들고 23까지 반복
)
SELECT h.hour AS HOUR, COUNT(a.ANIMAL_ID) AS COUNT -- h.hour는 0부터 23까지 만든 숫자
FROM hours h
LEFT JOIN ANIMAL_OUTS a ON HOUR(a.DATETIME) = h.hour -- 모든 시간대가 결과에 나오도록 LEFT JOIN
GROUP BY h.hour -- 집계하려면 꼭 필요
ORDER BY h.hour;