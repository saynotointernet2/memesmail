DROP FUNCTION mm_store_object(user_id mm_user_id, body mm_object_body, keys mm_object_keys);
DROP FUNCTION mm_add_keys(owner_id mm_user_id, obj_id mm_object_id, keys mm_object_keys);
DROP FUNCTION mm_edit_body(owner_id mm_user_id, obj_id mm_object_id, newbody mm_object_body);
DROP FUNCTION mm_edit_object(owner_id mm_user_id, obj_id mm_object_id, newbody mm_object_body, keys mm_object_keys);
DROP FUNCTION mm_edit_key(owner_id mm_user_id, obj_id mm_object_id, objkey_id mm_object_key_id, newkey mm_object_key);
DROP FUNCTION mm_load_object_with_key(owner_id mm_user_id, obj_id mm_object_id, objkey_id mm_object_key_id);
DROP FUNCTION mm_load_object_full(owner_id mm_user_id, obj_id mm_object_id);
DROP FUNCTION mm_load_all_ids(owner_id mm_user_id);
DROP FUNCTION mm_remove_object(owner_id mm_user_id, obj_id mm_object_id);
DROP FUNCTION mm_remove_keys(owner_id mm_user_id, obj_id mm_object_id, objkey_ids mm_object_key_ids);

DROP TABLE public.mm_user;
DROP TABLE public.mm_object;
DROP TABLE public.mm_object_key_table;

DROP TYPE mm_object_stored_ids;
DROP TYPE mm_object_load_key;
DROP TYPE mm_object_key_id_pair;
DROP TYPE mm_object_load_full;

DROP DOMAIN mm_user_id;
DROP DOMAIN mm_login_token;
DROP DOMAIN mm_object_body;
DROP DOMAIN mm_object_key;
DROP DOMAIN mm_object_keys;
DROP DOMAIN mm_object_id;
DROP DOMAIN mm_object_ids;
DROP DOMAIN mm_object_key_id;
DROP DOMAIN mm_object_key_ids;
