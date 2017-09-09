-- Store new object for specified user
CREATE OR REPLACE FUNCTION mm_store_object(user_id mm_user_id, body mm_object_body, keys mm_object_keys) RETURNS mm_object_stored_ids AS $$
  DECLARE
    stored_ids mm_object_stored_ids;
    obj_id mm_object_id;
    obj_keys_array varchar(255)[] := keys;
    obj_key_ids varchar(255)[] := '{}';
    obj_key_id varchar(255);
    obj_key mm_object_key;
  BEGIN
    INSERT INTO mm_object (user_id, body) VALUES (user_id, body) RETURNING object_id INTO obj_id;
    FOREACH obj_key IN ARRAY obj_keys_array
    LOOP
      INSERT INTO mm_object_key_table (object_id, object_key) VALUES (obj_id, obj_key) RETURNING key_id INTO obj_key_id;
      obj_key_ids := array_append(obj_key_ids, obj_key_id);
    END LOOP;
    stored_ids.object_id = obj_id;
    stored_ids.key_ids = obj_key_ids;
    RETURN stored_ids;
  END
$$ LANGUAGE plpgsql;


-- Add more keys for specified data object
CREATE OR REPLACE FUNCTION mm_add_keys(owner_id mm_user_id, obj_id mm_object_id, keys mm_object_keys) RETURNS mm_object_key_ids AS $$
  DECLARE
    obj_keys_array varchar(255)[] := keys;
    obj_key_ids varchar(255)[] := '{}';
    obj_key_id varchar(255);
    obj_key mm_object_key;
  BEGIN
    IF EXISTS (SELECT * FROM mm_object obj WHERE obj.user_id = owner_id AND obj.object_id = obj_id) 
    THEN
      FOREACH obj_key IN ARRAY obj_keys_array
      LOOP
        INSERT INTO mm_object_key_table (object_id, object_key) VALUES (obj_id, obj_key) RETURNING key_id INTO obj_key_id;
        obj_key_ids := array_append(obj_key_ids, obj_key_id);
      END LOOP;
    END IF;
    RETURN obj_key_ids;
  END
$$ LANGUAGE plpgsql;


-- Edit the body of an object for specified object_id and user
CREATE OR REPLACE FUNCTION mm_edit_body(owner_id mm_user_id, obj_id mm_object_id, newbody mm_object_body) RETURNS BOOLEAN AS $$
  DECLARE
    result BOOLEAN := false;
  BEGIN
    UPDATE mm_object SET body = newbody WHERE object_id = obj_id AND user_id = owner_id RETURNING TRUE INTO result;
    RETURN result;
  END
$$ LANGUAGE plpgsql;


-- Store new object for specified user
CREATE OR REPLACE FUNCTION mm_edit_object(owner_id mm_user_id, obj_id mm_object_id, newbody mm_object_body, keys mm_object_keys) RETURNS mm_object_key_ids AS $$
  DECLARE
    obj_keys_array varchar(255)[] := keys;
    obj_key_ids varchar(255)[] := '{}';
    obj_key_id varchar(255);
    obj_key mm_object_key;
  BEGIN
    IF EXISTS (SELECT * FROM mm_object obj WHERE obj.user_id = owner_id AND obj.object_id = obj_id) 
    THEN
      UPDATE mm_object SET body = newbody WHERE object_id = obj_id AND user_id = owner_id;
      DELETE FROM mm_object_key_table WHERE object_id = obj_id;
      FOREACH obj_key IN ARRAY obj_keys_array
      LOOP
        INSERT INTO mm_object_key_table (object_id, object_key) VALUES (obj_id, obj_key) RETURNING key_id INTO obj_key_id;
        obj_key_ids := array_append(obj_key_ids, obj_key_id);
      END LOOP;
    END IF;
    RETURN obj_key_ids;
  END
$$ LANGUAGE plpgsql;


-- Edit key for specified user and object and key_id
CREATE OR REPLACE FUNCTION mm_edit_key(owner_id mm_user_id, obj_id mm_object_id, objkey_id mm_object_key_id, newkey mm_object_key) RETURNS BOOLEAN AS $$
  DECLARE
    result BOOLEAN := false;
  BEGIN
    IF EXISTS (SELECT * FROM mm_object obj WHERE obj.user_id = owner_id AND obj.object_id = obj_id)
    THEN
      UPDATE mm_object_key_table SET object_key = newkey WHERE object_id = obj_id AND key_id = objkey_id RETURNING TRUE INTO result;
      RETURN result;
    END IF;
  END;
$$ LANGUAGE plpgsql;


-- Look up specific object with specific key for specific user by ids
CREATE OR REPLACE FUNCTION mm_load_object_with_key(owner_id mm_user_id, obj_id mm_object_id, objkey_id mm_object_key_id) RETURNS mm_object_load_key AS $$
  DECLARE
    result mm_object_load_key;
    resbody mm_object_body := NULL;
    reskey mm_object_key := NULL;
  BEGIN
    IF (EXISTS (SELECT * FROM mm_object obj WHERE obj.user_id = owner_id AND obj.object_id = obj_id)) AND
      (EXISTS (SELECT * FROM mm_object_key_table keys WHERE keys.object_id = obj_id AND keys.key_id = objkey_id))
    THEN
      SELECT obj.body INTO resbody FROM mm_object obj WHERE obj.user_id = owner_id AND obj.object_id = obj_id;
      SELECT keys.object_key INTO reskey FROM mm_object_key_table keys WHERE keys.object_id = obj_id AND keys.key_id = objkey_id;
    END IF;
    result.body = resbody;
    result.object_key = reskey;
    RETURN result;
  END;
$$ LANGUAGE plpgsql;


-- Look up specific object with all keys for specific user by ids
CREATE OR REPLACE FUNCTION mm_load_object_full(owner_id mm_user_id, obj_id mm_object_id) RETURNS mm_object_load_full AS $$
  DECLARE
    result mm_object_load_full;
    resbody mm_object_body := NULL;
    reskeys mm_object_keys := '{}';
  BEGIN
    IF (EXISTS (SELECT * FROM mm_object obj WHERE obj.user_id = owner_id AND obj.object_id = obj_id))
    THEN
      SELECT obj.body INTO resbody FROM mm_object obj WHERE obj.user_id = owner_id AND obj.object_id = obj_id;
      reskeys := ARRAY(SELECT ROW(keys.key_id, keys.object_key) FROM mm_object_key_table keys WHERE keys.object_id = obj_id);
    END IF;
    result.body = resbody;
    result.object_keys= reskeys;
    RETURN result;
  END;
$$ LANGUAGE plpgsql;


-- Get all object ids belonging to specific user. Because postgresql doesn't support arrays of varchars we need to tuple the string first.
CREATE OR REPLACE FUNCTION mm_load_all_ids(owner_id mm_user_id) RETURNS mm_object_ids AS $$
  DECLARE
    result mm_object_ids := '{}';
  BEGIN
    result := ARRAY(SELECT ROW(obj.object_id) FROM mm_object obj WHERE obj.user_id = owner_id);
    RETURN result;
  END;
$$ LANGUAGE plpgsql;


-- Remove object for specific user by id.
CREATE OR REPLACE FUNCTION mm_remove_object(owner_id mm_user_id, obj_id mm_object_id) RETURNS VOID AS $$
  BEGIN
    DELETE FROM mm_object obj WHERE obj.user_id = owner_id AND obj.object_id = obj_id;
  END;
$$ LANGUAGE plpgsql;


-- Remove key for specified object and user by id.
CREATE OR REPLACE FUNCTION mm_remove_keys(owner_id mm_user_id, obj_id mm_object_id, objkey_ids mm_object_key_ids) RETURNS VOID AS $$
  BEGIN
    IF (EXISTS (SELECT * FROM mm_object obj WHERE obj.user_id = owner_id AND obj.object_id = obj_id))
    THEN
      DELETE FROM mm_object_key_table keys WHERE keys.object_id = obj_id AND keys.key_id = ANY(objkey_ids::varchar(255)[]);
    END IF;
  END;
$$ LANGUAGE plpgsql;


