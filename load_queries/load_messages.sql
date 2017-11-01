LOAD FROM post_view AS row 
   MATCH (p:person), (f:forum), (pl:place)
   WHERE p.id = (row).personId 
     AND f.id = (row).forumId 
     AND pl.id = (row).placeId
   CREATE (:post =
        JSONB_SET(
          JSONB_SET(
    	    JSONB_SET(
    		  JSONB_STRIP_NULLS(ROW_TO_JSON(row)), '{gid_creator}', TO_JSONB(ID(p))), 
    			  '{gid_forumid}', TO_JSONB(ID(f))), '{gid_place}', TO_JSONB(ID(pl))));
LOAD FROM comment_view AS row
   MATCH (p:person), (pl:place)
   WHERE p.id = (row).personId AND pl.id = (row).placeId
   CREATE (:"Comment" = JSONB_SET(JSONB_SET(JSONB_STRIP_NULLS(ROW_TO_JSON(row)),
           '{gid_creator}', TO_JSONB(ID(p))), '{gid_place}', TO_JSONB(ID(pl))));
