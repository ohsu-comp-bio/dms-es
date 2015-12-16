
SELECT
 CONCAT('AML-',disease_instance.patient) as individual_id,
 CONCAT('AML-',specimen.id) as sample_id,
 healthcare_location.description as original_specimen_location,
 specimen_processing.description as  processing,
 specimen_type.description as specimen_type,
 yes_no_unknown.description as  sufficient,
 cell_concentration,
 cell_viability,
 dilution_for_cell_count,
 resuspension_volume,
 total_cells_viable,
 volume
FROM
 specimen
 left JOIN healthcare_location on healthcare_location.id = original_specimen_location
 left JOIN specimen_type on specimen_type.id = specimen_type
 left JOIN specimen_processing on specimen_processing.id = processing
 left JOIN yes_no_unknown on yes_no_unknown.id = sufficient
 left JOIN disease_instance on disease_instance.id = disease_instance
