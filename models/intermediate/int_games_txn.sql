{{ config(materialized='table') }}

with final as (

  select  
  date,
  CAST(REPLACE(realamount, ',', '.') AS FLOAT8) AS realamount_float,
  CAST(REPLACE(bonusamount, ',', '.') AS FLOAT8) AS bonusamount_float,
  channeluid,
  txcurrency,
  gameid,
  txtype,
  betid,
  playerid
  from "dev"."datalake_staging_spectrum".stg_gamestransaction         

)


select * from final