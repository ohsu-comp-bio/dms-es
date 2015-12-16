
SELECT
  patient,
  FLOOR(DATEDIFF(diagnosis_date,patient.date_of_birth)/365)   as age_at_diagnosis,
  diagnosis.description as diagnosis
FROM  disease_instance
  JOIN diagnosis on disease_instance.diagnosis = diagnosis.id
  JOIN patient   on disease_instance.patient = patient.id 
