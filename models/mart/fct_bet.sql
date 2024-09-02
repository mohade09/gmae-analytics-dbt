{{ config(materialized='table') }}


with bets as (

    select * from {{ ref('int_games_txn') }}

),

currency as (

    select * from {{ ref('int_txn_currency') }}

),


bets_currency as 

(
    SELECT 
    b.date,
    b.realamount_float*c.baserateeuro_float as realamount_float_eur,
    b.bonusamount_float*c.baserateeuro_float as bonusamount_float_eur,
    b.channeluid,
    b.txcurrency,
    b.gameid,
    b.txtype,
    b.betid,
    b.playerid
    from 
        bets as b,
        currency as c
    where 
        b.date =c.date 
        and b.txcurrency  = c.currency
),

final as 
(
select 
    bc.date,bc.playerid,bc.gameid,
    sum(CASE WHEN bc.txtype = 'WAGER' THEN bc.realamount_float_eur ELSE 0 END) AS cash_turnover,
    sum(CASE WHEN bc.txtype = 'WAGER' THEN bc.bonusamount_float_eur ELSE 0 END) AS bonous_turnover,
    sum(CASE WHEN bc.txtype = 'RESULT' THEN bc.realamount_float_eur ELSE 0 END) AS cash_winnings,
    sum(CASE WHEN bc.txtype = 'RESULT' THEN bc.bonusamount_float_eur ELSE 0 END) AS bonous_winings,
    cash_turnover+bonous_turnover as turnover,
    cash_winnings+bonous_winings as winnings,
    cash_turnover-cash_winnings as cash_result,
    bonous_turnover-bonous_winings as bonous_result,
    turnover-winnings as gross_result

from 
    bets_currency as bc
group by 
    bc.date,bc.playerid,bc.gameid    
)


select * from final