WITH DATE_R_FORMAT AS(
        SELECT ((to_date(substr(RES_DATE,0,10)||' '||substr(RES_DATE,12,8),
                    'YYYY-MM-DD HH24:MI:SS') - to_date(substr(REQ_DATE,0,10)||' '||substr(REQ_DATE,12,8), 
                                                        'YYYY-MM-DD HH24:MI:SS')) *24*3600 ) diff_time
        FROM TRANSACTIONS
        WHERE REQ_DATE LIKE P:YEAR || '-' || P:MONTH || '-' || P:DAY || 'T' || P:HOUR || '%' -- for format like yyyy-mm-ddThh%
)
SELECT  percentile_cont (0.95) WITHIN GROUP
            (ORDER BY diff_time ASC) as percentile_95,
        max(diff_time),
        ROUND(AVG(diff_time), 2), 
        count(*)
FROM DATE_R_FORMAT
