{{
    config(
        materialized='ephemeral'
    )
}}

with flattened as (
    select
        business_id,
        try_parse_json(attribute_value) as attribute_value
    from {{ ref('business_attributes_flattened') }}
    where attribute_key = 'hairspecializesin'
),

hair_flattened as (
    select
        business_id,
        lower(a.key) as hair_key,
        a.value::boolean as hair_value
    from flattened,
    lateral flatten(input => attribute_value) as a
)

select *
from hair_flattened
pivot(
    max(hair_value)
    for hair_key in ('coloring', 'extensions', 'perms', 'straightperms', 'africanamerican', 'asian', 'curly', 'kids')
) as p (business_id, hair_coloring, hair_extensions, hair_perms, hair_straightperms, hair_africanamerican, hair_asian, hair_curly, hair_kids)