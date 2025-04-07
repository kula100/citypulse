{{
    config(
        materialized='table'
    )
}}

with
opening_hrs as (
    select *
    from {{ ref('business_opening_hrs') }}
),

closing_hrs as (
    select *
    from {{ ref('business_closing_hrs') }}
)

select
    o.business_id,
    o.monday_open,
    c.monday_close,
    o.tuesday_open,
    c.tuesday_close,
    o.wednesday_open,
    c.wednesday_close,
    o.thursday_open,
    c.thursday_close,
    o.friday_open,
    c.friday_close,
    o.saturday_open,
    c.saturday_close,
    o.sunday_open,
    c.sunday_close
from opening_hrs as o
inner join closing_hrs as c
    on o.business_id = c.business_id

{{ limit_records(1000) }}
