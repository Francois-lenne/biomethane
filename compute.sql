

/*

Here we compute the production of biomethane by region

*/


CREATE OR REPLACE TABLE production_by_region AS
SELECT 
    NOM_REGION, 
    SUM(PRODUCTION_BIOMETHANE) AS PRODUCTION_BIOMETHANE_TOTAL
FROM 
    "PROJET_PERSO"."PUBLIC"."biomethane"
GROUP BY 
    NOM_REGION
ORDER BY 
    SUM(PRODUCTION_BIOMETHANE) DESC;



/*

Here we compute the production of biomethane by date

*/



CREATE OR REPLACE TABLE total_production_by_date AS
SELECT 
    DATE, 
    SUM(PRODUCTION_BIOMETHANE) AS PRODUCTION_BIOMETHANE_TOTAL
FROM 
    "PROJET_PERSO"."PUBLIC"."biomethane"
GROUP BY 
    DATE
ORDER BY 
    SUM(PRODUCTION_BIOMETHANE) DESC;


/*

Here we compute the production of biomethane by producer and by date

*/


CREATE OR REPLACE TABLE total_production_by_operator_and_date AS
SELECT 
    OPERATEUR_DE_TRANSPORT,
    DATE, 
    SUM(PRODUCTION_BIOMETHANE) AS PRODUCTION_BIOMETHANE_TOTAL
FROM 
    "PROJET_PERSO"."PUBLIC"."biomethane"
GROUP BY 
    OPERATEUR_DE_TRANSPORT, 
    DATE
ORDER BY 
    SUM(PRODUCTION_BIOMETHANE) DESC;


/*

Here we compute a windows functions that make a classement of the region by date

*/

CREATE VIEW classement_region_by_dates AS
SELECT 
    NOM_REGION, 
    date, 
    SUM(PRODUCTION_BIOMETHANE) AS Total_Production,
    RANK() OVER(PARTITION BY date ORDER BY SUM(PRODUCTION_BIOMETHANE) DESC) AS Rank
FROM 
    "PROJET_PERSO"."PUBLIC"."biomethane"
GROUP BY 
    NOM_REGION, date
ORDER BY
    date;