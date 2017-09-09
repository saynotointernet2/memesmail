CREATE DOMAIN mm_user_id as character varying(255)

CREATE DOMAIN mm_login_token as character varying(255)

CREATE DOMAIN mm_object_body as bytea

CREATE DOMAIN mm_object_key as character varying(255)

CREATE DOMAIN mm_object_keys as character varying(255)[] DEFAULT '{}'

CREATE DOMAIN mm_object_id as character varying(255)

CREATE DOMAIN mm_object_ids as character varying(255)[] DEFAULT '{}'

CREATE DOMAIN mm_object_key_id as character varying(255)

CREATE DOMAIN mm_object_key_ids as character varying(255)[] DEFAULT '{}'
