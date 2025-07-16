SELECT 
    d.ID,
    d.EMAIL,
    d.FIRST_NAME,
    d.LAST_NAME
FROM DEVELOPERS d
JOIN SKILLCODES s ON (d.SKILL_CODE & s.CODE) = s.CODE -- 개발자가 가진 스킬 코드에 해당 스킬의 비트가 포함되어 있나 확인
WHERE s.NAME IN ('Python', 'C#')
GROUP BY d.ID, d.EMAIL, d.FIRST_NAME, d.LAST_NAME -- 중복제거
ORDER BY d.ID;