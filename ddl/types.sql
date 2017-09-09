-- Types used to return from functions
CREATE TYPE mm_user_id AS (
  user_id varchar(255)
);

CREATE TYPE mm_login_token AS (
  login_token varchar(255)
);

CREATE TYPE mm_object_body AS (
  object_body bytea
);

CREATE TYPE mm_object_key AS (
  object_key varchar(255)
);

CREATE TYPE mm_object_id AS (
  object_id varchar(255)
);

CREATE TYPE mm_object_key_id AS (
  object_key_id varchar(255)
);

CREATE TYPE mm_object_stored_ids AS (
  object_id	mm_object_id,
  key_ids	mm_object_key_id[]
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
);
