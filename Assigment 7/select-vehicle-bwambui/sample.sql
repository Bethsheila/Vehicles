-- Report the number of older (pre 1990) registrations

SELECT myear,
    count(myear)
FROM registration
WHERE myear < 1990
GROUP BY myear
ORDER BY myear;