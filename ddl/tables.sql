-- User table. Stores user ids, login tokens, root object ids

CREATE TABLE public.mm_user
(
  user_id mm_user_id NOT NULL,
  login_token mm_login_token,
  storage_root mm_object_body,
  CONSTRAINT mm_user_pkey PRIMARY KEY (user_id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.mm_user
  OWNER TO postgres;
GRANT ALL ON TABLE public.mm_user TO postgres;
GRANT SELECT, UPDATE, INSERT ON TABLE public.mm_user TO memesmail_clients;


-- Object table stores users' object bodies and object ids references users through user id. Auto generates ids.

CREATE TABLE public.mm_object
(
  object_id mm_object_id NOT NULL DEFAULT ROW(encode(decode(replace(((gen_random_uuid())::character varying)::text, '-'::text, ''::text), 'hex'::text), 'base64'::text)),
  user_id mm_user_id,
  body mm_object_body,
  CONSTRAINT mm_object_pkey PRIMARY KEY (object_id),
  CONSTRAINT mm_object_user_id_fkey FOREIGN KEY (user_id)
      REFERENCES public.mm_user (user_id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.mm_object
  OWNER TO postgres;
GRANT ALL ON TABLE public.mm_object TO postgres;
GRANT SELECT, UPDATE, INSERT ON TABLE public.mm_object TO memesmail_clients;


-- Object keys table, stores key ids, keys by reference to object through object id. Auto generates ids.
CREATE TABLE public.mm_object_key_table
(
  key_id mm_object_key_id NOT NULL DEFAULT ROW(encode(decode(replace(((gen_random_uuid())::character varying)::text, '-'::text, ''::text), 'hex'::text), 'base64'::text)),
  object_id mm_object_id,
  object_key mm_object_key,
  CONSTRAINT mm_object_key_table_key PRIMARY KEY (key_id),
  CONSTRAINT mm_object_key_table_object_id_fkey FOREIGN KEY (object_id)
      REFERENCES public.mm_object (object_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.mm_object_key_table
  OWNER TO postgres;
GRANT ALL ON TABLE public.mm_object_key_table TO postgres;
GRANT SELECT, UPDATE, INSERT ON TABLE public.mm_object_key_table TO memesmail_clients;
