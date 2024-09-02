{% snapshot players_snapshot %}

{{
    config(
      target_schema = 'public',
      unique_key='playerid',

      strategy='timestamp',
      updated_at='latestupdate',
    )
}}

select * from "dev"."datalake_staging_spectrum"."stg_player"

{% endsnapshot %}