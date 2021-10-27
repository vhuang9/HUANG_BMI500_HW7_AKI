WITH patient_stays AS(
    SELECT p.SUBJECT_ID, p.GENDER, icu.admission_age, icu.icustay_id, icu.hadm_id
    FROM `physionet-data.mimiciii_clinical.patients` p 
    INNER JOIN `physionet-data.mimiciii_derived.icustay_detail` icu
    ON p.SUBJECT_ID = icu.SUBJECT_ID
    ORDER BY p.SUBJECT_ID, icu.ICUSTAY_ID
),
patient_staging AS(
    SELECT patient_stays.SUBJECT_ID, patient_stays.GENDER, patient_stays.admission_age,
    patient_stays.icustay_id, patient_stays.hadm_id, kdigo.aki_stage, rrt.RRT,
    kdigo.aki_stage_uo,kdigo.uo_rt_12hr,kdigo.uo_rt_24hr,
    kdigo.uo_rt_6hr, creat.creat
    FROM patient_stays 
    INNER JOIN `physionet-data.mimiciii_derived.kdigo_stages` kdigo
    ON patient_stays.ICUSTAY_ID = kdigo.icustay_id
    INNER JOIN `physionet-data.mimiciii_derived.kdigo_creatinine` creat
    ON patient_stays.icustay_id = creat.icustay_id
    INNER JOIN `physionet-data.mimiciii_derived.rrt` rrt
    ON patient_stays.icustay_id = rrt.icustay_id
) 
SELECT *
FROM patient_staging 
WHERE patient_staging.aki_stage != 0

