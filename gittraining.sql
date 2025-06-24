with electorate as (
  select 
    person_id,
    cd,
    cycle_race
  from demsdccc.dccc_staging.stg_person_electorate stg
  where stg.cd = 'MD-02'
    and stg.cycle_year = 2020
    and stg.cycle_is_current_voter = true
)
-- voter history data
, voted as (
  select
    person_id,
    vote_p_2020,
    vote_p_2020_party_d
  from democrats.analytics.person_votes pv
)

select
  cd,
  cycle_race,
  sum(vote_p_2020) as voted_2020,
  round(sum(vote_p_2020) / sum(sum(vote_p_2020)) over() * 100,1) share
from electorate e
left join voted v on e.person_id = v.person_id
group by 1,2
order by 1,2;