select
  CONCAT('AML-',patient.id) as individual_id,
  ethnicity.description as ethnicity,
  gender.description as gender,
  race.description as race,
  vital_status.description as vital_status,
  diagnosis.description as diagnosis,
  patient.comment as patient_comment,
  FLOOR(DATEDIFF(diagnosis_date,patient.date_of_birth)/365)   as age_at_diagnosis
from patient
  left join ethnicity on patient.ethnicity = ethnicity.id
  left join gender on patient.gender = gender.id
  left join race on patient.race = race.id
  left join vital_status on patient.race = vital_status.id
  left join disease_instance on patient.id = disease_instance.patient
  left join diagnosis on disease_instance.diagnosis = diagnosis.id
 
