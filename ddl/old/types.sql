-- Types used to return from functions
CREATE TYPE mm_object_stored_ids AS (
  object_id	mm_object_id,
  key_ids	mm_object_key_ids
);

CREATE TYPE mm_object_load_key AS (
  body       mm_object_body,
  object_key   mm_object_key
);

CREATE TYPE mm_object_key_id_pair AS (
  key_id  mm_object_key_id,
  key mm_object_key
);

CREATE TYPE mm_object_load_full AS (
    body       mm_object_body,
    object_keys  mm_object_key_id_pair[]
)
