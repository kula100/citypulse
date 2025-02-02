{{
    config(
        materialized='ephemeral'
    )
}}

select
    business_id,
    acceptsinsurance::boolean as acceptsinsurance,
    businessacceptscreditcards::boolean as businessacceptscreditcards,
    businessacceptsbitcoin::boolean as businessacceptsbitcoin
from {{ ref('business_attributes_flattened') }}
pivot(
    max(attribute_value)
    for attribute_key in ('acceptsinsurance', 'businessacceptscreditcards', 'businessacceptsbitcoin')
) as p (business_id, acceptsinsurance, businessacceptscreditcards, businessacceptsbitcoin)
