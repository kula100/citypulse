{{
    config(
        materialized='table'
    )
}}

select
    rst.business_id,
    rst.restaurantsdelivery::boolean as restaurantsdelivery,
    rst.drivethru::boolean as drivethru,
    rst.byobcorkage as byobcorkage,
    rst.byob,
    rst.coatcheck,
    rst.happyhour,
    rst.hastv,
    rst.restaurantspricerange2,
    rst.restaurantsreservations,
    rst.restaurantstakeout,
    rst.restaurantsgoodforgroups,
    rst.alcohol,
    rst.corkage,
    rst.caters,
    rst.outdoorseating,
    rst.restaurantsattire,
    rst.restaurantstableservice,
    rst.restaurantscounterservice,
    rst.goodfordancing,
    pets.dogsallowed,
    ages.agesallowed,
    ages.goodforkids,
    amb.amb_casual,
    amb.amb_classy,
    amb.amb_divey,
    amb.amb_hipster,
    amb.amb_intimate,
    amb.amb_romantic,
    amb.amb_touristy,
    amb.amb_trendy,
    amb.amb_upscale,
    mus.music_background_music,
    mus.music_dj,
    mus.music_jukebox,
    mus.music_karaoke,
    mus.music_live,
    mus.music_video,
    park.business_parking_garage,
    park.business_parking_street,
    park.business_parking_validated,
    park.business_parking_lot,
    park.business_parking_valet,
    park.bike_parking,
    park.wheelchair_accessible,
    bnt.bestnights_friday,
    bnt.bestnights_monday,
    bnt.bestnights_saturday,
    bnt.bestnights_sunday,
    bnt.bestnights_thursday,
    bnt.bestnights_tuesday,
    bnt.bestnights_wednesday,
    cmn.noiselevel,
    cmn.byappointmentonly,
    cmn.wifi,
    cmn.smoking,
    cmn.open24hours,
    gfm.goodformeal_dessert,
    gfm.goodformeal_latenight,
    gfm.goodformeal_lunch,
    gfm.goodformeal_dinner,
    gfm.goodformeal_brunch,
    gfm.goodformeal_breakfast,
    pmt.acceptsinsurance,
    pmt.businessacceptscreditcards,
    pmt.businessacceptsbitcoin,
    dr.diet_dairy_free,
    dr.diet_gluten_free,
    dr.diet_vegan,
    dr.diet_kosher,
    dr.diet_halal,
    dr.diet_soy_free,
    dr.diet_vegetarian,
    hr.hair_coloring,
    hr.hair_extensions,
    hr.hair_perms,
    hr.hair_straightperms,
    hr.hair_africanamerican,
    hr.hair_asian,
    hr.hair_curly,
    hr.hair_kids,
    {{ executed_at() }}
from {{ ref('business_attributes_restaurent') }} as rst
left join {{ ref('business_attributes_pets') }} as pets
    on rst.business_id = pets.business_id
left join {{ ref('business_attributes_ages') }} as ages
    on rst.business_id = ages.business_id
left join {{ ref('business_attributes_ambience') }} as amb
    on rst.business_id = amb.business_id
left join {{ ref('business_attributes_music') }} as mus
    on rst.business_id = mus.business_id
left join {{ ref('business_attributes_parking') }} as park
    on rst.business_id = park.business_id
left join {{ ref('business_attributes_bestnights') }} as bnt
    on rst.business_id = bnt.business_id
left join {{ ref('business_attributes_common') }} as cmn
    on rst.business_id = cmn.business_id
left join {{ ref('business_attributes_goodformeal') }} as gfm
    on rst.business_id = gfm.business_id
left join {{ ref('business_attributes_payments') }} as pmt
    on rst.business_id = pmt.business_id
left join {{ ref('business_attributes_dietary_restrictions') }} as dr
    on rst.business_id = dr.business_id
left join {{ ref('business_attributes_hairspecializesin') }} as hr
    on rst.business_id = hr.business_id
