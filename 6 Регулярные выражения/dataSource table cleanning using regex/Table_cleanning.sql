-- No need to create table, because I have already done this.
-- And it was safed on my local pc

SELECT * FROM datasource;


-- Cleanning Firstname with regex

SELECT first_name FROM datasource WHERE REGEXP_LIKE(first_name, '.')

SELECT last_name FROM datasource WHERE REGEXP_LIKE(last_name, '.')

-- ????????? ?? null ?? ?????????? ????????. ??? ????? ??????? ??????
SELECT
    CASE
        WHEN REGEXP_LIKE(FIRST_NAME, '\.')
        THEN substr(LAST_NAME, 1, instr(LAST_NAME, ' '))
        WHEN instr(FIRST_NAME, ' ') != 0
        THEN substr(FIRST_NAME, 1, instr(FIRST_NAME, ' '))
        ELSE FIRST_NAME
    END AS new_first_name
FROM DATASOURCE;

-- Cleanning Firstname with string functions
SELECT
    CASE
        WHEN FIRST_NAME is null
        THEN substr(LAST_NAME, 1, instr(LAST_NAME, ' '))
        WHEN instr(FIRST_NAME, ' ') != 0
        THEN substr(FIRST_NAME, 1, instr(FIRST_NAME, ' '))
        ELSE FIRST_NAME
    END AS new_first_name
FROM DATASOURCE;



-- Cleaninng whole table with string functions
SELECT 
     CASE
        WHEN FIRST_NAME is null
        THEN substr(LAST_NAME, 1, instr(LAST_NAME, ' '))
        WHEN instr(FIRST_NAME, ' ') != 0
        THEN substr(FIRST_NAME, 1, instr(FIRST_NAME, ' '))
        ELSE FIRST_NAME
    END AS new_first_name,
    CASE
        WHEN LAST_NAME is null
        THEN substr(FIRST_NAME, instr(FIRST_NAME, ' ') +1)
        WHEN instr(LAST_NAME, ' ') != 0
        THEN substr(LAST_NAME, instr(LAST_NAME, ' '))
        ELSE LAST_NAME
    END AS new_last_name,
    CASE
        WHEN instr(email, '@') != 0
        THEN (
            case
                when instr(email, ' ') != 0
                then substr(email, 1, instr(email, ' ') -1)
                else email
            end
            )
        else null
    end as email,
    CASE
        WHEN substr(upper(GENDER), 1, 1) = 'F'
        THEN '1'
        ELSE '0'
    END AS binGender,
    CASE
    WHEN instr(email, '@') != 0
    THEN (
        CASE
            WHEN instr(email, ' ') != 0
            THEN substr(email, instr(email, ' ')+1)
            ELSE null
        END
        )
    ELSE email
    END AS phone
FROM DATASOURCE;
