{{
    config(
        materialized='incremental'
    )
}}

with players as (
  select * from "dev"."datalake_staging_spectrum"."stg_player"
),

windowed as (
  select   
   players.*,
   rank() over (partition by playerid order by  latestupdate desc) as rownum
   
  from players

  {% if is_incremental() %}
    -- if the table doesn't exist, then every order row will be processed. 
    -- If it does, then only rows that have changed since the last invocation need to be processed.
    where latestupdate > (select max(latestupdate) from {{ this }})
  {% endif %}
),

final as (
  select 
   *,current_timestamp as dbt_updated_date
  from windowed
  where rownum  = 1
)

select * from final