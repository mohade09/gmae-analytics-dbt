{{ config(materialized='table') }}


with final as (
    select
    date,
    CAST(baserateeuro AS FLOAT8) as baserateeuro_float,
    currency
    from 
    "dev"."datalake_staging_spectrum".stg_currencyexchange 
    
)

select * from final