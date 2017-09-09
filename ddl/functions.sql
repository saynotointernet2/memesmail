-- Store new object for specified user
CREATE OR REPLACE FUNCTION mm_store_object(ouser mm_user_id, obody mm_object_body, keys mm_object_key[]) RETURNS mm_object_stored_ids AS $$ DECLARE
    stored_ids mm_object_stored_ids;
    obj_id mm_object_id;
    obj_key_ids mm_object_key_id[] := '{}';
    obj_key_id mm_object_key_id;
    obj_key mm_object_key;
  BEGIN
    INSERT INTO mm_object (user_id, body) VALUES (ouser, obody) RETURNING (object_id).* INTO obj_id;
    FOREACH obj_key IN ARRAY keys
    LOOP
      INSERT INTO mm_object_key_table (object_id, object_key) VALUES (obj_id, obj_key) RETURNING (key_id).* INTO obj_key_id;
      obj_key_ids := array_append(obj_key_ids, obj_key_id);
    END LOOP;
    stored_ids.object_id = obj_id;
    stored_ids.key_ids = obj_key_ids;
    RETURN stored_ids;
  END
$$ LANGUAGE plpgsql;


-- Add more keys for specified data object
CREATE OR REPLACE FUNCTION mm_add_keys(owner_id mm_user_id, obj_id mm_object_id, keys mm_object_key[]) RETURNS mm_object_key_id[] AS $$
  DECLARE
    obj_key_ids mm_object_key_id[] := '{}';
    obj_key_id mm_object_key_id;
    obj_key mm_object_key;
  BEGIN
    IF EXISTS (SELECT * FROM mm_object obj WHERE obj.user_id = owner_id AND obj.object_id = obj_id) 
    THEN
      FOREACH obj_key IN ARRAY keys
      LOOP
        INSERT INTO mm_object_key_table (object_id, object_key) VALUES (obj_id, obj_key) RETURNING (key_id).* INTO obj_key_id;
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
CREATE OR REPLACE FUNCTION mm_edit_object(owner_id mm_user_id, obj_id mm_object_id, newbody mm_object_body, keys mm_object_key[]) RETURNS mm_object_key_id[] AS $$
  DECLARE
    obj_key_ids mm_object_key_id[] := '{}';
    obj_key_id mm_object_key_id;
    obj_key mm_object_key;
  BEGIN
    IF EXISTS (SELECT * FROM mm_object obj WHERE obj.user_id = owner_id AND obj.object_id = obj_id) 
    THEN
      UPDATE mm_object SET body = newbody WHERE object_id = obj_id AND user_id = owner_id;
      DELETE FROM mm_object_key_table WHERE object_id = obj_id;
      FOREACH obj_key IN ARRAY keys
      LOOP
        INSERT INTO mm_object_key_table (object_id, object_key) VALUES (obj_id, obj_key) RETURNING (key_id).* INTO obj_key_id;
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
  BEGIN
    IF (EXISTS (SELECT * FROM mm_object obj WHERE obj.user_id = owner_id AND obj.object_id = obj_id)) AND
      (EXISTS (SELECT * FROM mm_object_key_table keys WHERE keys.object_id = obj_id AND keys.key_id = objkey_id))
    THEN
	    SELECT obj.body, keys.object_key INTO result
	    FROM mm_object obj, mm_object_key_table keys
	    WHERE keys.object_id = obj_id AND keys.key_id = objkey_id;
    END IF;
    RETURN result;
  END;
$$ LANGUAGE plpgsql;


-- Look up specific object with all keys for specific user by ids
CREATE OR REPLACE FUNCTION mm_load_object_full(owner_id mm_user_id, obj_id mm_object_id) RETURNS mm_object_load_full AS $$
  DECLARE
    result mm_object_load_full;
    resbody mm_object_body;
    reskeys mm_object_key_id_pair[] := '{}';
  BEGIN
    IF (EXISTS (SELECT * FROM mm_object obj WHERE obj.user_id = owner_id AND obj.object_id = obj_id))
    THEN
      SELECT (obj.body).* INTO resbody FROM mm_object obj WHERE obj.user_id = owner_id AND obj.object_id = obj_id;
      reskeys := ARRAY(SELECT CAST(ROW(keys.key_id, keys.object_key) as mm_object_key_id_pair) FROM mm_object_key_table keys WHERE keys.object_id = obj_id);
      result.body = resbody;
      result.object_keys= reskeys;
    END IF;
    RETURN result;
  END;
$$ LANGUAGE plpgsql;


-- Get all object ids belonging to specific user. Because postgresql doesn't support arrays of varchars we need to tuple the string first.
CREATE OR REPLACE FUNCTION mm_load_all_ids(owner_id mm_user_id) RETURNS mm_object_id[] AS $$
  DECLARE
    result mm_object_id[] := '{}';
  BEGIN
    result := ARRAY(SELECT ROW(obj.object_id) FROM mm_object obj WHERE obj.user_id = owner_id);
    RETURN result;
  END;
$$ LANGUAGE plpgsql;


-- Get root object body for the specified user.
CREATE OR REPLACE FUNCTION mm_load_root_object(owner_id mm_user_id) RETURNS mm_object_body AS $$
  DECLARE
    result mm_object_body;
  BEGIN
    SELECT (obj.body).* INTO result FROM mm_object obj, mm_user usr WHERE
    usr.user_id = owner_id AND
    obj.object_id = usr.storage_root
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
CREATE OR REPLACE FUNCTION mm_remove_keys(owner_id mm_user_id, obj_id mm_object_id, objkey_ids mm_object_key_id[]) RETURNS VOID AS $$
  BEGIN
    IF (EXISTS (SELECT * FROM mm_object obj WHERE obj.user_id = owner_id AND obj.object_id = obj_id))
    THEN
      DELETE FROM mm_object_key_table keys WHERE keys.object_id = obj_id AND keys.key_id = ANY(objkey_ids::mm_object_key_id[]);
    END IF;
  END;
$$ LANGUAGE plpgsql;


