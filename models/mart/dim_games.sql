
-- Use the `ref` function to select from other models

{{ config(materialized='table') }}



with games as (

    select * from "dev"."datalake_staging_spectrum"."stg_games"

),


gamesprovider as (

    select * from "dev"."datalake_staging_spectrum"."stg_gameprovider"

),


gamescategory as (

    select * from "dev"."datalake_staging_spectrum"."stg_gamescategory"

),

final as (
select 
    g.id as game_id,
    g.game_name as game_name ,
    gp.game_provider_name as game_provider_name,
    gc.game_category as game_category

from 
    games as  g 
LEFT OUTER JOIN 
    gamesprovider as gp on g.gameproviderid  = gp.id
LEFT OUTER JOIN 
    gamescategory as gc on g.id = gc.game_id

)


select * from final


