SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '"$user",public', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: btree_gist; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS btree_gist WITH SCHEMA public;


--
-- Name: EXTENSION btree_gist; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION btree_gist IS 'support for indexing common datatypes in GiST';


--
-- Name: citext; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS citext WITH SCHEMA public;


--
-- Name: EXTENSION citext; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION citext IS 'data type for case-insensitive character strings';


--
-- Name: intarray; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS intarray WITH SCHEMA public;


--
-- Name: EXTENSION intarray; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION intarray IS 'functions, operators, and index support for 1-D arrays of integers';


--
-- Name: ltree; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS ltree WITH SCHEMA public;


--
-- Name: EXTENSION ltree; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION ltree IS 'data type for hierarchical tree-like structures';


--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: asset_kind; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.asset_kind AS ENUM (
    'unknown',
    'image',
    'video',
    'audio',
    'pdf',
    'document',
    'archive'
);


--
-- Name: collection_link_operator; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.collection_link_operator AS ENUM (
    'contains',
    'references'
);


--
-- Name: collection_linked_item_operator; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.collection_linked_item_operator AS ENUM (
    'contains',
    'references'
);


--
-- Name: contributor_kind; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.contributor_kind AS ENUM (
    'person',
    'organization'
);


--
-- Name: entity_visibility; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.entity_visibility AS ENUM (
    'visible',
    'hidden',
    'limited'
);


--
-- Name: item_link_operator; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.item_link_operator AS ENUM (
    'contains',
    'references'
);


--
-- Name: jsonb_auth_path_state; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.jsonb_auth_path_state AS (
	path public.ltree,
	granted boolean
);


--
-- Name: link_operator; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.link_operator AS ENUM (
    'contains',
    'references'
);


--
-- Name: parsed_semver; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.parsed_semver AS (
	major integer,
	minor integer,
	patch integer,
	pre public.citext,
	build public.citext
);


--
-- Name: permission_kind; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.permission_kind AS ENUM (
    'contextual',
    'global'
);


--
-- Name: schema_kind; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.schema_kind AS ENUM (
    'community',
    'collection',
    'item',
    'metadata'
);


--
-- Name: semantic_version; Type: DOMAIN; Schema: public; Owner: -
--

CREATE DOMAIN public.semantic_version AS public.citext DEFAULT '0.0.0'::public.citext
	CONSTRAINT semver_format_applies CHECK ((VALUE OPERATOR(public.~) '^(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)(?:-((?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\.(?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\+([0-9a-zA-Z-]+(?:\.[0-9a-zA-Z-]+)*))?$'::public.citext));


--
-- Name: _jsonb_auth_path_acc(public.jsonb_auth_path_state[], public.ltree, boolean); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public._jsonb_auth_path_acc(public.jsonb_auth_path_state[], public.ltree, boolean) RETURNS public.jsonb_auth_path_state[]
    LANGUAGE sql IMMUTABLE
    AS $_$ SELECT $1 || ($2, $3)::jsonb_auth_path_state; $_$;


--
-- Name: _jsonb_auth_path_final(public.jsonb_auth_path_state[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public._jsonb_auth_path_final(public.jsonb_auth_path_state[]) RETURNS jsonb
    LANGUAGE sql IMMUTABLE
    AS $_$ SELECT jsonb_set_agg(to_jsonb(x.granted), string_to_array(x.path::text, '.')) FROM ( SELECT y.path, bool_or(y.granted) AS granted FROM unnest($1) AS y(path, granted) GROUP BY y.path ) x $_$;


--
-- Name: array_distinct(anyarray); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.array_distinct(anyarray) RETURNS anyarray
    LANGUAGE sql IMMUTABLE
    AS $_$ SELECT array_agg(DISTINCT x) FILTER (WHERE x IS NOT NULL) FROM unnest($1) t(x); $_$;


--
-- Name: calculate_visibility_range(public.entity_visibility, timestamp with time zone, timestamp with time zone); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.calculate_visibility_range(public.entity_visibility, after timestamp with time zone, until timestamp with time zone) RETURNS tstzrange
    LANGUAGE sql IMMUTABLE PARALLEL SAFE
    AS $_$
SELECT CASE
WHEN $1 = 'limited' AND ($2 IS NOT NULL OR $3 IS NOT NULL)
THEN tstzrange($2, $3, '[)')
ELSE
  NULL
END;
$_$;


--
-- Name: jsonb_bool_or_rec(jsonb, boolean, text[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.jsonb_bool_or_rec(jsonb, boolean, text[]) RETURNS jsonb
    LANGUAGE sql IMMUTABLE
    AS $_$ SELECT jsonb_set_rec($1, to_jsonb(jsonb_extract_boolean($1, $3) OR $2), $3); $_$;


--
-- Name: jsonb_extract_boolean(jsonb, text[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.jsonb_extract_boolean(jsonb, text[]) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$ SELECT CASE jsonb_typeof($1 #> $2) WHEN 'boolean' THEN ($1 #> $2)::boolean ELSE FALSE END; $_$;


--
-- Name: jsonb_set_rec(jsonb, jsonb, text[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.jsonb_set_rec(jsonb, jsonb, text[]) RETURNS jsonb
    LANGUAGE sql IMMUTABLE
    AS $_$ SELECT CASE WHEN array_length($3, 1) > 1 and ($1 #> $3[:array_upper($3, 1) - 1]) is null THEN jsonb_set_rec($1, jsonb_build_object($3[array_upper($3, 1)], $2), $3[:array_upper($3, 1) - 1]) ELSE jsonb_set($1, $3, $2, true) END $_$;


--
-- Name: parse_semver(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.parse_semver(text) RETURNS public.parsed_semver
    LANGUAGE sql IMMUTABLE STRICT PARALLEL SAFE
    AS $_$ SELECT (a[1], a[2], a[3], a[4], a[5])::parsed_semver FROM ( SELECT '^(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)(?:-((?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\.(?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\+([0-9a-zA-Z-]+(?:\.[0-9a-zA-Z-]+)*))?$' AS pat ) p LEFT JOIN LATERAL ( SELECT regexp_matches($1, p.pat) AS a ) match ON true WHERE match.a IS NOT NULL; $_$;


--
-- Name: array_accum(anyarray); Type: AGGREGATE; Schema: public; Owner: -
--

CREATE AGGREGATE public.array_accum(anyarray) (
    SFUNC = array_cat,
    STYPE = anyarray,
    INITCOND = '{}'
);


--
-- Name: array_accum_distinct(anyarray); Type: AGGREGATE; Schema: public; Owner: -
--

CREATE AGGREGATE public.array_accum_distinct(anyarray) (
    SFUNC = array_cat,
    STYPE = anyarray,
    INITCOND = '{}',
    FINALFUNC = public.array_distinct
);


--
-- Name: jsonb_auth_path(public.ltree, boolean); Type: AGGREGATE; Schema: public; Owner: -
--

CREATE AGGREGATE public.jsonb_auth_path(public.ltree, boolean) (
    SFUNC = public._jsonb_auth_path_acc,
    STYPE = public.jsonb_auth_path_state[],
    INITCOND = '{}',
    FINALFUNC = public._jsonb_auth_path_final
);


--
-- Name: jsonb_bool_or(boolean, text[]); Type: AGGREGATE; Schema: public; Owner: -
--

CREATE AGGREGATE public.jsonb_bool_or(boolean, text[]) (
    SFUNC = public.jsonb_bool_or_rec,
    STYPE = jsonb,
    INITCOND = '{}'
);


--
-- Name: jsonb_set_agg(jsonb, text[]); Type: AGGREGATE; Schema: public; Owner: -
--

CREATE AGGREGATE public.jsonb_set_agg(jsonb, text[]) (
    SFUNC = public.jsonb_set_rec,
    STYPE = jsonb,
    INITCOND = '{}'
);


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: access_grants; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.access_grants (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    accessible_type character varying NOT NULL,
    accessible_id uuid NOT NULL,
    role_id uuid NOT NULL,
    user_id uuid,
    auth_path public.ltree NOT NULL,
    community_id uuid,
    collection_id uuid,
    item_id uuid,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    user_group_id uuid,
    subject_type character varying NOT NULL,
    subject_id uuid NOT NULL
);


--
-- Name: authorizing_entities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.authorizing_entities (
    auth_path public.ltree NOT NULL,
    entity_id uuid NOT NULL,
    scope public.ltree NOT NULL,
    hierarchical_type text NOT NULL,
    hierarchical_id uuid NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: granted_permissions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.granted_permissions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    access_grant_id uuid NOT NULL,
    permission_id uuid NOT NULL,
    user_id uuid NOT NULL,
    scope public.ltree NOT NULL,
    action public.ltree NOT NULL,
    role_id uuid NOT NULL,
    accessible_type text NOT NULL,
    accessible_id uuid NOT NULL,
    auth_path public.ltree NOT NULL,
    inferred boolean DEFAULT false NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: contextual_single_permissions; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.contextual_single_permissions AS
 SELECT ent.hierarchical_id,
    ent.hierarchical_type,
    gp.user_id,
    gp.permission_id,
    gp.action,
    gp.access_grant_id,
    gp.role_id,
    info.directly_assigned
   FROM ((public.granted_permissions gp
     JOIN public.authorizing_entities ent USING (auth_path, scope))
     LEFT JOIN LATERAL ( SELECT ((gp.accessible_type = ent.hierarchical_type) AND (gp.accessible_id = ent.hierarchical_id)) AS directly_assigned) info ON (true))
  WHERE ((NOT info.directly_assigned) OR (NOT gp.inferred));


--
-- Name: permissions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.permissions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    kind public.permission_kind NOT NULL,
    path public.ltree NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    scope public.ltree GENERATED ALWAYS AS (public.subpath(path, 0, '-1'::integer)) STORED,
    name public.ltree GENERATED ALWAYS AS (public.subpath(path, '-1'::integer, 1)) STORED,
    jsonb_path text[] GENERATED ALWAYS AS (string_to_array((path)::text, '.'::text)) STORED,
    self_path_old public.ltree GENERATED ALWAYS AS (
CASE kind
    WHEN 'contextual'::public.permission_kind THEN
    CASE public.subpath(path, 0, '-1'::integer)
        WHEN 'self'::public.ltree THEN NULL::public.ltree
        ELSE (public.ltree2text('self'::public.ltree) OPERATOR(public.||) public.subpath(path, '-1'::integer, 1))
    END
    ELSE NULL::public.ltree
END) STORED,
    self_prefixed boolean GENERATED ALWAYS AS ((path OPERATOR(public.~) 'self.*'::public.lquery)) STORED,
    infix public.ltree GENERATED ALWAYS AS (public.subpath(path, 1, 1)) STORED,
    suffix public.ltree GENERATED ALWAYS AS (public.subpath(path, 1, (public.nlevel(path) - 1))) STORED,
    self_path public.ltree GENERATED ALWAYS AS (
CASE kind
    WHEN 'contextual'::public.permission_kind THEN
    CASE public.subpath(path, 0, 1)
        WHEN 'self'::public.ltree THEN NULL::public.ltree
        ELSE (public.ltree2text('self'::public.ltree) OPERATOR(public.||) public.subpath(path, 1, (public.nlevel(path) - 1)))
    END
    ELSE NULL::public.ltree
END) STORED,
    head public.ltree GENERATED ALWAYS AS (public.subpath(path, 0, 1)) STORED,
    inheritance public.ltree[] DEFAULT '{}'::public.ltree[] NOT NULL
);


--
-- Name: access_grant_management_links; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.access_grant_management_links AS
 SELECT ag.id AS access_grant_id,
    csp.user_id
   FROM ((public.access_grants ag
     JOIN public.permissions mp ON ((mp.path OPERATOR(public.=) 'self.manage_access'::public.ltree)))
     JOIN public.contextual_single_permissions csp ON (((csp.hierarchical_type = (ag.accessible_type)::text) AND (csp.hierarchical_id = ag.accessible_id) AND (csp.permission_id = mp.id))));


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: asset_hierarchies; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.asset_hierarchies (
    ancestor_id uuid NOT NULL,
    descendant_id uuid NOT NULL,
    generations integer NOT NULL
);


--
-- Name: assets; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.assets (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    attachable_type character varying NOT NULL,
    attachable_id uuid NOT NULL,
    parent_id uuid,
    kind public.asset_kind DEFAULT 'unknown'::public.asset_kind NOT NULL,
    "position" integer,
    name public.citext,
    content_type public.citext,
    file_size bigint,
    alt_text text,
    caption text,
    attachment_data jsonb,
    alternatives_data jsonb,
    preview_data jsonb,
    properties jsonb,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    community_id uuid,
    collection_id uuid,
    item_id uuid
);


--
-- Name: collections; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.collections (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    community_id uuid NOT NULL,
    schema_definition_id uuid NOT NULL,
    parent_id uuid,
    identifier public.citext NOT NULL,
    system_slug public.citext NOT NULL,
    title public.citext,
    doi public.citext,
    summary text DEFAULT ''::text NOT NULL,
    thumbnail_data jsonb,
    properties jsonb,
    published_on date,
    visible_after_at timestamp with time zone,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    auth_path public.ltree NOT NULL,
    hierarchical_depth integer GENERATED ALWAYS AS (public.nlevel(auth_path)) STORED,
    schema_version_id uuid NOT NULL,
    visible_until_at timestamp with time zone,
    hidden_at timestamp with time zone,
    visibility public.entity_visibility DEFAULT 'visible'::public.entity_visibility NOT NULL,
    visibility_range tstzrange GENERATED ALWAYS AS (public.calculate_visibility_range(visibility, visible_after_at, visible_until_at)) STORED
);


--
-- Name: communities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.communities (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    system_slug public.citext NOT NULL,
    "position" integer,
    title public.citext NOT NULL,
    thumbnail_data jsonb,
    metadata jsonb,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    auth_path public.ltree NOT NULL,
    hierarchical_depth integer GENERATED ALWAYS AS (public.nlevel(auth_path)) STORED,
    schema_definition_id uuid NOT NULL,
    schema_version_id uuid NOT NULL,
    properties jsonb
);


--
-- Name: collection_authorizations; Type: MATERIALIZED VIEW; Schema: public; Owner: -
--

CREATE MATERIALIZED VIEW public.collection_authorizations AS
 WITH RECURSIVE closure_tree(community_id, collection_id, auth_path) AS (
         SELECT coll.community_id,
            coll.id AS collection_id,
            (comm.auth_path OPERATOR(public.||) public.text2ltree((coll.system_slug)::text)) AS auth_path
           FROM (public.collections coll
             JOIN public.communities comm ON ((comm.id = coll.community_id)))
          WHERE (coll.parent_id IS NULL)
        UNION ALL
         SELECT coll.community_id,
            coll.id AS collection_id,
            (ct.auth_path OPERATOR(public.||) public.text2ltree((coll.system_slug)::text)) AS auth_path
           FROM (public.collections coll
             JOIN closure_tree ct ON ((ct.collection_id = coll.parent_id)))
        )
 SELECT closure_tree.community_id,
    closure_tree.collection_id,
    closure_tree.auth_path
   FROM closure_tree
  WITH NO DATA;


--
-- Name: collection_contributions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.collection_contributions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    contributor_id uuid NOT NULL,
    collection_id uuid NOT NULL,
    kind public.citext,
    metadata jsonb,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: collection_hierarchies; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.collection_hierarchies (
    ancestor_id uuid NOT NULL,
    descendant_id uuid NOT NULL,
    generations integer NOT NULL
);


--
-- Name: collection_linked_items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.collection_linked_items (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    source_id uuid NOT NULL,
    target_id uuid NOT NULL,
    operator public.collection_linked_item_operator NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: collection_links; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.collection_links (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    source_id uuid NOT NULL,
    target_id uuid NOT NULL,
    operator public.collection_link_operator NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: community_memberships; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.community_memberships (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    community_id uuid NOT NULL,
    role_id uuid,
    user_id uuid NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: contextual_permissions; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.contextual_permissions AS
 SELECT ent.hierarchical_id,
    ent.hierarchical_type,
    gp.user_id,
    true AS has_any_role,
    bool_or(info.directly_assigned) AS has_direct_role,
    array_agg(DISTINCT gp.access_grant_id) AS access_grant_ids,
    array_agg(DISTINCT gp.role_id) AS role_ids,
    array_agg(DISTINCT gp.action) AS allowed_actions,
    public.jsonb_auth_path(gp.action, true) AS access_control_list,
    public.jsonb_auth_path(public.subpath(gp.action, 1, (public.nlevel(gp.action) - 1)), true) FILTER (WHERE (gp.action OPERATOR(public.~) 'self.*'::public.lquery)) AS grid,
    min(gp.created_at) AS created_at,
    max(gp.updated_at) AS updated_at
   FROM ((public.granted_permissions gp
     JOIN public.authorizing_entities ent USING (auth_path, scope))
     LEFT JOIN LATERAL ( SELECT ((gp.accessible_type = ent.hierarchical_type) AND (gp.accessible_id = ent.hierarchical_id)) AS directly_assigned) info ON (true))
  WHERE ((NOT info.directly_assigned) OR (NOT gp.inferred))
  GROUP BY ent.hierarchical_id, ent.hierarchical_type, gp.user_id;


--
-- Name: contextually_assigned_access_grants; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.contextually_assigned_access_grants AS
 SELECT ent.hierarchical_id,
    ent.hierarchical_type,
    gp.user_id,
    gp.access_grant_id
   FROM ((public.granted_permissions gp
     JOIN public.authorizing_entities ent USING (auth_path, scope))
     LEFT JOIN LATERAL ( SELECT ((gp.accessible_type = ent.hierarchical_type) AND (gp.accessible_id = ent.hierarchical_id)) AS directly_assigned) info ON (true))
  WHERE ((NOT info.directly_assigned) OR (NOT gp.inferred))
  GROUP BY ent.hierarchical_id, ent.hierarchical_type, gp.user_id, gp.access_grant_id;


--
-- Name: contextually_assigned_roles; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.contextually_assigned_roles AS
 SELECT ent.hierarchical_id,
    ent.hierarchical_type,
    gp.user_id,
    gp.role_id
   FROM ((public.granted_permissions gp
     JOIN public.authorizing_entities ent USING (auth_path, scope))
     LEFT JOIN LATERAL ( SELECT ((gp.accessible_type = ent.hierarchical_type) AND (gp.accessible_id = ent.hierarchical_id)) AS directly_assigned) info ON (true))
  WHERE ((NOT info.directly_assigned) OR (NOT gp.inferred))
  GROUP BY ent.hierarchical_id, ent.hierarchical_type, gp.user_id, gp.role_id;


--
-- Name: contributors; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.contributors (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    kind public.contributor_kind NOT NULL,
    identifier public.citext NOT NULL,
    email public.citext,
    prefix text,
    suffix text,
    bio text,
    url text,
    image_data jsonb,
    properties jsonb,
    links jsonb,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: entities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.entities (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    entity_type text NOT NULL,
    entity_id uuid NOT NULL,
    hierarchical_type text NOT NULL,
    hierarchical_id uuid NOT NULL,
    system_slug public.citext NOT NULL,
    auth_path public.ltree NOT NULL,
    scope public.ltree NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    depth integer GENERATED ALWAYS AS (public.nlevel(auth_path)) STORED,
    schema_version_id uuid NOT NULL,
    link_operator public.link_operator
);


--
-- Name: entity_breadcrumbs; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.entity_breadcrumbs AS
 SELECT ent.entity_type,
    ent.entity_id,
    ent.system_slug AS entity_slug,
    crumb.entity_type AS crumb_type,
    crumb.entity_id AS crumb_id,
    crumb.auth_path,
    crumb.system_slug,
    crumb.depth
   FROM (public.entities ent
     JOIN public.entities crumb ON (((ent.auth_path OPERATOR(public.<@) crumb.auth_path) AND (crumb.entity_id <> ent.entity_id))));


--
-- Name: entity_links; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.entity_links (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    source_type character varying NOT NULL,
    source_id uuid NOT NULL,
    target_type character varying NOT NULL,
    target_id uuid NOT NULL,
    schema_version_id uuid NOT NULL,
    source_community_id uuid,
    source_collection_id uuid,
    source_item_id uuid,
    target_community_id uuid,
    target_collection_id uuid,
    target_item_id uuid,
    operator public.link_operator NOT NULL,
    auth_path public.ltree NOT NULL,
    scope public.ltree NOT NULL,
    system_slug public.citext NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.items (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    collection_id uuid NOT NULL,
    schema_definition_id uuid NOT NULL,
    parent_id uuid,
    identifier public.citext NOT NULL,
    system_slug public.citext NOT NULL,
    title public.citext,
    doi public.citext,
    summary text DEFAULT ''::text NOT NULL,
    thumbnail_data jsonb,
    properties jsonb,
    published_on date,
    visible_after_at timestamp with time zone,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    auth_path public.ltree NOT NULL,
    hierarchical_depth integer GENERATED ALWAYS AS (public.nlevel(auth_path)) STORED,
    schema_version_id uuid NOT NULL,
    visible_until_at timestamp with time zone,
    hidden_at timestamp with time zone,
    visibility public.entity_visibility DEFAULT 'visible'::public.entity_visibility NOT NULL,
    visibility_range tstzrange GENERATED ALWAYS AS (public.calculate_visibility_range(visibility, visible_after_at, visible_until_at)) STORED
);


--
-- Name: item_authorizations; Type: MATERIALIZED VIEW; Schema: public; Owner: -
--

CREATE MATERIALIZED VIEW public.item_authorizations AS
 WITH RECURSIVE collection_paths(community_id, collection_id, auth_path) AS (
         SELECT coll.community_id,
            coll.id AS collection_id,
            (comm.auth_path OPERATOR(public.||) public.text2ltree((coll.system_slug)::text)) AS auth_path
           FROM (public.collections coll
             JOIN public.communities comm ON ((comm.id = coll.community_id)))
          WHERE (coll.parent_id IS NULL)
        UNION ALL
         SELECT coll.community_id,
            coll.id AS collection_id,
            (ct.auth_path OPERATOR(public.||) public.text2ltree((coll.system_slug)::text)) AS auth_path
           FROM (public.collections coll
             JOIN collection_paths ct ON ((ct.collection_id = coll.parent_id)))
        ), item_paths(community_id, collection_id, item_id, auth_path) AS (
         SELECT coll.community_id,
            i.collection_id,
            i.id AS item_id,
            (coll.auth_path OPERATOR(public.||) public.text2ltree((i.system_slug)::text)) AS auth_path
           FROM (public.items i
             JOIN collection_paths coll USING (collection_id))
          WHERE (i.parent_id IS NULL)
        UNION ALL
         SELECT coll.community_id,
            i.collection_id,
            i.id AS item_id,
            (ip.auth_path OPERATOR(public.||) public.text2ltree((i.system_slug)::text)) AS auth_path
           FROM ((public.items i
             JOIN collection_paths coll USING (collection_id))
             JOIN item_paths ip ON ((ip.item_id = i.parent_id)))
        )
 SELECT item_paths.community_id,
    item_paths.collection_id,
    item_paths.item_id,
    item_paths.auth_path
   FROM item_paths
  WITH NO DATA;


--
-- Name: item_contributions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.item_contributions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    contributor_id uuid NOT NULL,
    item_id uuid NOT NULL,
    kind public.citext,
    metadata jsonb,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: item_hierarchies; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.item_hierarchies (
    ancestor_id uuid NOT NULL,
    descendant_id uuid NOT NULL,
    generations integer NOT NULL
);


--
-- Name: item_links; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.item_links (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    source_id uuid NOT NULL,
    target_id uuid NOT NULL,
    operator public.item_link_operator NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: ordering_entries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ordering_entries (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    ordering_id uuid NOT NULL,
    entity_id uuid NOT NULL,
    entity_type text NOT NULL,
    "position" bigint NOT NULL,
    link_operator public.link_operator,
    auth_path public.ltree NOT NULL,
    scope public.ltree NOT NULL,
    relative_depth integer NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
)
PARTITION BY HASH (ordering_id);


--
-- Name: ordering_entries_part_1; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ordering_entries_part_1 (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    ordering_id uuid NOT NULL,
    entity_id uuid NOT NULL,
    entity_type text NOT NULL,
    "position" bigint NOT NULL,
    link_operator public.link_operator,
    auth_path public.ltree NOT NULL,
    scope public.ltree NOT NULL,
    relative_depth integer NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
ALTER TABLE ONLY public.ordering_entries ATTACH PARTITION public.ordering_entries_part_1 FOR VALUES WITH (modulus 8, remainder 0);


--
-- Name: ordering_entries_part_2; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ordering_entries_part_2 (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    ordering_id uuid NOT NULL,
    entity_id uuid NOT NULL,
    entity_type text NOT NULL,
    "position" bigint NOT NULL,
    link_operator public.link_operator,
    auth_path public.ltree NOT NULL,
    scope public.ltree NOT NULL,
    relative_depth integer NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
ALTER TABLE ONLY public.ordering_entries ATTACH PARTITION public.ordering_entries_part_2 FOR VALUES WITH (modulus 8, remainder 1);


--
-- Name: ordering_entries_part_3; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ordering_entries_part_3 (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    ordering_id uuid NOT NULL,
    entity_id uuid NOT NULL,
    entity_type text NOT NULL,
    "position" bigint NOT NULL,
    link_operator public.link_operator,
    auth_path public.ltree NOT NULL,
    scope public.ltree NOT NULL,
    relative_depth integer NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
ALTER TABLE ONLY public.ordering_entries ATTACH PARTITION public.ordering_entries_part_3 FOR VALUES WITH (modulus 8, remainder 2);


--
-- Name: ordering_entries_part_4; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ordering_entries_part_4 (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    ordering_id uuid NOT NULL,
    entity_id uuid NOT NULL,
    entity_type text NOT NULL,
    "position" bigint NOT NULL,
    link_operator public.link_operator,
    auth_path public.ltree NOT NULL,
    scope public.ltree NOT NULL,
    relative_depth integer NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
ALTER TABLE ONLY public.ordering_entries ATTACH PARTITION public.ordering_entries_part_4 FOR VALUES WITH (modulus 8, remainder 3);


--
-- Name: ordering_entries_part_5; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ordering_entries_part_5 (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    ordering_id uuid NOT NULL,
    entity_id uuid NOT NULL,
    entity_type text NOT NULL,
    "position" bigint NOT NULL,
    link_operator public.link_operator,
    auth_path public.ltree NOT NULL,
    scope public.ltree NOT NULL,
    relative_depth integer NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
ALTER TABLE ONLY public.ordering_entries ATTACH PARTITION public.ordering_entries_part_5 FOR VALUES WITH (modulus 8, remainder 4);


--
-- Name: ordering_entries_part_6; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ordering_entries_part_6 (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    ordering_id uuid NOT NULL,
    entity_id uuid NOT NULL,
    entity_type text NOT NULL,
    "position" bigint NOT NULL,
    link_operator public.link_operator,
    auth_path public.ltree NOT NULL,
    scope public.ltree NOT NULL,
    relative_depth integer NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
ALTER TABLE ONLY public.ordering_entries ATTACH PARTITION public.ordering_entries_part_6 FOR VALUES WITH (modulus 8, remainder 5);


--
-- Name: ordering_entries_part_7; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ordering_entries_part_7 (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    ordering_id uuid NOT NULL,
    entity_id uuid NOT NULL,
    entity_type text NOT NULL,
    "position" bigint NOT NULL,
    link_operator public.link_operator,
    auth_path public.ltree NOT NULL,
    scope public.ltree NOT NULL,
    relative_depth integer NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
ALTER TABLE ONLY public.ordering_entries ATTACH PARTITION public.ordering_entries_part_7 FOR VALUES WITH (modulus 8, remainder 6);


--
-- Name: ordering_entries_part_8; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ordering_entries_part_8 (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    ordering_id uuid NOT NULL,
    entity_id uuid NOT NULL,
    entity_type text NOT NULL,
    "position" bigint NOT NULL,
    link_operator public.link_operator,
    auth_path public.ltree NOT NULL,
    scope public.ltree NOT NULL,
    relative_depth integer NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
ALTER TABLE ONLY public.ordering_entries ATTACH PARTITION public.ordering_entries_part_8 FOR VALUES WITH (modulus 8, remainder 7);


--
-- Name: schema_definitions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_definitions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name public.citext NOT NULL,
    identifier public.citext NOT NULL,
    system_slug public.citext NOT NULL,
    kind public.schema_kind NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    namespace public.citext NOT NULL
);


--
-- Name: schema_versions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_versions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    schema_definition_id uuid NOT NULL,
    current boolean DEFAULT false NOT NULL,
    system_slug public.citext NOT NULL,
    configuration jsonb DEFAULT '{}'::jsonb NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    number public.semantic_version NOT NULL,
    "position" integer,
    parsed public.parsed_semver GENERATED ALWAYS AS (public.parse_semver((number)::text)) STORED
);


--
-- Name: ordering_entry_candidates; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.ordering_entry_candidates AS
 SELECT ent.entity_type,
    ent.entity_id,
    ent.hierarchical_type,
    ent.hierarchical_id,
    ent.auth_path,
    ent.scope,
    ent.schema_version_id,
    ent.link_operator,
    ent.depth AS entity_depth,
    sv.number AS schema_number,
    sv.parsed AS schema_parsed_number,
    sv.system_slug AS schema_slug,
    sd.kind AS schema_consumer,
    sd.identifier AS schema_identifier,
    sd.namespace AS schema_namespace,
    sd.name AS schema_name,
    ent.created_at AS entity_created_at,
    ent.updated_at AS entity_updated_at,
    src.title AS entity_title,
    src.published_on AS entity_published_on,
    src.properties AS entity_properties
   FROM ((((((public.entities ent
     JOIN public.schema_versions sv ON ((sv.id = ent.schema_version_id)))
     JOIN public.schema_definitions sd ON ((sd.id = sv.schema_definition_id)))
     LEFT JOIN public.entity_links link ON (((ent.entity_type = 'EntityLink'::text) AND (ent.entity_id = link.id))))
     LEFT JOIN public.collections collection ON (((ent.hierarchical_type = 'Collection'::text) AND (ent.hierarchical_id = collection.id))))
     LEFT JOIN public.items item ON (((ent.hierarchical_type = 'Item'::text) AND (ent.hierarchical_id = item.id))))
     LEFT JOIN LATERAL ( SELECT
                CASE ent.hierarchical_type
                    WHEN 'Collection'::text THEN collection.title
                    WHEN 'Item'::text THEN item.title
                    ELSE NULL::public.citext
                END AS title,
                CASE ent.hierarchical_type
                    WHEN 'Collection'::text THEN collection.published_on
                    WHEN 'Item'::text THEN item.published_on
                    ELSE NULL::date
                END AS published_on,
                CASE ent.hierarchical_type
                    WHEN 'Collection'::text THEN collection.properties
                    WHEN 'Item'::text THEN item.properties
                    ELSE NULL::jsonb
                END AS properties) src ON (true));


--
-- Name: orderings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.orderings (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    entity_type character varying NOT NULL,
    entity_id uuid NOT NULL,
    schema_version_id uuid NOT NULL,
    community_id uuid,
    collection_id uuid,
    item_id uuid,
    identifier public.citext NOT NULL,
    inherited_from_schema boolean DEFAULT false NOT NULL,
    definition jsonb DEFAULT '{}'::jsonb NOT NULL,
    disabled_at timestamp without time zone,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: role_permissions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.role_permissions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    permission_id uuid NOT NULL,
    role_id uuid NOT NULL,
    action public.ltree NOT NULL,
    inferring_actions public.ltree[] DEFAULT '{}'::public.ltree[] NOT NULL,
    inferring_scopes public.ltree[] DEFAULT '{}'::public.ltree[] NOT NULL,
    inferred boolean DEFAULT false NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: roles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.roles (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name public.citext NOT NULL,
    system_slug public.citext NOT NULL,
    access_control_list jsonb DEFAULT '{}'::jsonb NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    allowed_actions public.ltree[] DEFAULT '{}'::public.ltree[] NOT NULL
);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: schematic_collected_references; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schematic_collected_references (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    referrer_type character varying NOT NULL,
    referrer_id uuid NOT NULL,
    referent_type character varying NOT NULL,
    referent_id uuid NOT NULL,
    path public.citext NOT NULL,
    "position" integer,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: schematic_scalar_references; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schematic_scalar_references (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    referrer_type character varying NOT NULL,
    referrer_id uuid NOT NULL,
    referent_type character varying NOT NULL,
    referent_id uuid NOT NULL,
    path public.citext NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: tmp_agu; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.tmp_agu AS
 SELECT ag.id AS access_grant_id,
    csp.user_id
   FROM ((public.access_grants ag
     JOIN public.permissions mp ON ((mp.path OPERATOR(public.=) 'self.manage_access'::public.ltree)))
     JOIN public.contextual_single_permissions csp ON (((csp.hierarchical_type = (ag.accessible_type)::text) AND (csp.hierarchical_id = ag.accessible_id) AND (csp.user_id = ag.user_id) AND (csp.permission_id = mp.id))))
  GROUP BY ag.id, csp.user_id;


--
-- Name: user_group_memberships; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_group_memberships (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    user_group_id uuid NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: user_groups; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_groups (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    keycloak_id uuid,
    system_slug public.citext NOT NULL,
    name public.citext NOT NULL,
    description public.citext NOT NULL,
    metadata jsonb DEFAULT '{}'::jsonb NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    keycloak_id uuid NOT NULL,
    system_slug public.citext NOT NULL,
    email_verified boolean DEFAULT false NOT NULL,
    email public.citext NOT NULL,
    username public.citext NOT NULL,
    name text DEFAULT ''::text NOT NULL,
    given_name text DEFAULT ''::text NOT NULL,
    family_name text DEFAULT ''::text NOT NULL,
    roles text[] DEFAULT '{}'::text[] NOT NULL,
    resource_roles jsonb DEFAULT '{}'::jsonb NOT NULL,
    metadata jsonb DEFAULT '{}'::jsonb NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    global_access_control_list jsonb DEFAULT '{}'::jsonb NOT NULL,
    allowed_actions public.ltree[] DEFAULT '{}'::public.ltree[] NOT NULL
);


--
-- Name: access_grants access_grants_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.access_grants
    ADD CONSTRAINT access_grants_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: assets assets_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assets
    ADD CONSTRAINT assets_pkey PRIMARY KEY (id);


--
-- Name: collection_contributions collection_contributions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.collection_contributions
    ADD CONSTRAINT collection_contributions_pkey PRIMARY KEY (id);


--
-- Name: collection_linked_items collection_linked_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.collection_linked_items
    ADD CONSTRAINT collection_linked_items_pkey PRIMARY KEY (id);


--
-- Name: collection_links collection_links_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.collection_links
    ADD CONSTRAINT collection_links_pkey PRIMARY KEY (id);


--
-- Name: collections collections_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.collections
    ADD CONSTRAINT collections_pkey PRIMARY KEY (id);


--
-- Name: communities communities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.communities
    ADD CONSTRAINT communities_pkey PRIMARY KEY (id);


--
-- Name: community_memberships community_memberships_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.community_memberships
    ADD CONSTRAINT community_memberships_pkey PRIMARY KEY (id);


--
-- Name: contributors contributors_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contributors
    ADD CONSTRAINT contributors_pkey PRIMARY KEY (id);


--
-- Name: entities entities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entities
    ADD CONSTRAINT entities_pkey PRIMARY KEY (id);


--
-- Name: entity_links entity_links_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entity_links
    ADD CONSTRAINT entity_links_pkey PRIMARY KEY (id);


--
-- Name: granted_permissions granted_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.granted_permissions
    ADD CONSTRAINT granted_permissions_pkey PRIMARY KEY (id);


--
-- Name: item_contributions item_contributions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.item_contributions
    ADD CONSTRAINT item_contributions_pkey PRIMARY KEY (id);


--
-- Name: item_links item_links_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.item_links
    ADD CONSTRAINT item_links_pkey PRIMARY KEY (id);


--
-- Name: items items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.items
    ADD CONSTRAINT items_pkey PRIMARY KEY (id);


--
-- Name: ordering_entries ordering_entries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ordering_entries
    ADD CONSTRAINT ordering_entries_pkey PRIMARY KEY (ordering_id, id);


--
-- Name: ordering_entries_part_1 ordering_entries_part_1_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ordering_entries_part_1
    ADD CONSTRAINT ordering_entries_part_1_pkey PRIMARY KEY (ordering_id, id);


--
-- Name: ordering_entries_part_2 ordering_entries_part_2_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ordering_entries_part_2
    ADD CONSTRAINT ordering_entries_part_2_pkey PRIMARY KEY (ordering_id, id);


--
-- Name: ordering_entries_part_3 ordering_entries_part_3_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ordering_entries_part_3
    ADD CONSTRAINT ordering_entries_part_3_pkey PRIMARY KEY (ordering_id, id);


--
-- Name: ordering_entries_part_4 ordering_entries_part_4_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ordering_entries_part_4
    ADD CONSTRAINT ordering_entries_part_4_pkey PRIMARY KEY (ordering_id, id);


--
-- Name: ordering_entries_part_5 ordering_entries_part_5_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ordering_entries_part_5
    ADD CONSTRAINT ordering_entries_part_5_pkey PRIMARY KEY (ordering_id, id);


--
-- Name: ordering_entries_part_6 ordering_entries_part_6_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ordering_entries_part_6
    ADD CONSTRAINT ordering_entries_part_6_pkey PRIMARY KEY (ordering_id, id);


--
-- Name: ordering_entries_part_7 ordering_entries_part_7_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ordering_entries_part_7
    ADD CONSTRAINT ordering_entries_part_7_pkey PRIMARY KEY (ordering_id, id);


--
-- Name: ordering_entries_part_8 ordering_entries_part_8_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ordering_entries_part_8
    ADD CONSTRAINT ordering_entries_part_8_pkey PRIMARY KEY (ordering_id, id);


--
-- Name: orderings orderings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orderings
    ADD CONSTRAINT orderings_pkey PRIMARY KEY (id);


--
-- Name: permissions permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_pkey PRIMARY KEY (id);


--
-- Name: role_permissions role_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_pkey PRIMARY KEY (id);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: schema_definitions schema_definitions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_definitions
    ADD CONSTRAINT schema_definitions_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: schema_versions schema_versions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_versions
    ADD CONSTRAINT schema_versions_pkey PRIMARY KEY (id);


--
-- Name: schematic_collected_references schematic_collected_references_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schematic_collected_references
    ADD CONSTRAINT schematic_collected_references_pkey PRIMARY KEY (id);


--
-- Name: schematic_scalar_references schematic_scalar_references_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schematic_scalar_references
    ADD CONSTRAINT schematic_scalar_references_pkey PRIMARY KEY (id);


--
-- Name: user_group_memberships user_group_memberships_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_group_memberships
    ADD CONSTRAINT user_group_memberships_pkey PRIMARY KEY (id);


--
-- Name: user_groups user_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_groups
    ADD CONSTRAINT user_groups_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: asset_anc_desc_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX asset_anc_desc_idx ON public.asset_hierarchies USING btree (ancestor_id, descendant_id, generations);


--
-- Name: asset_desc_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX asset_desc_idx ON public.asset_hierarchies USING btree (descendant_id);


--
-- Name: authorizing_entities_pkey; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX authorizing_entities_pkey ON public.authorizing_entities USING btree (auth_path, entity_id, scope, hierarchical_type, hierarchical_id);


--
-- Name: collection_anc_desc_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX collection_anc_desc_idx ON public.collection_hierarchies USING btree (ancestor_id, descendant_id, generations);


--
-- Name: collection_desc_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX collection_desc_idx ON public.collection_hierarchies USING btree (descendant_id);


--
-- Name: index_access_grants_on_accessible; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_access_grants_on_accessible ON public.access_grants USING btree (accessible_type, accessible_id);


--
-- Name: index_access_grants_on_auth_path; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_access_grants_on_auth_path ON public.access_grants USING gist (auth_path public.gist_ltree_ops (siglen='1024'));


--
-- Name: index_access_grants_on_collection_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_access_grants_on_collection_id ON public.access_grants USING btree (collection_id);


--
-- Name: index_access_grants_on_community_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_access_grants_on_community_id ON public.access_grants USING btree (community_id);


--
-- Name: index_access_grants_on_item_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_access_grants_on_item_id ON public.access_grants USING btree (item_id);


--
-- Name: index_access_grants_on_role_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_access_grants_on_role_id ON public.access_grants USING btree (role_id);


--
-- Name: index_access_grants_on_subject; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_access_grants_on_subject ON public.access_grants USING btree (subject_type, subject_id);


--
-- Name: index_access_grants_on_user_group_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_access_grants_on_user_group_id ON public.access_grants USING btree (user_group_id);


--
-- Name: index_access_grants_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_access_grants_on_user_id ON public.access_grants USING btree (user_id);


--
-- Name: index_access_grants_role_check; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_access_grants_role_check ON public.access_grants USING btree (accessible_type, accessible_id, role_id, subject_type, subject_id);


--
-- Name: index_access_grants_uniqueness; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_access_grants_uniqueness ON public.access_grants USING btree (accessible_type, accessible_id, subject_type, subject_id);


--
-- Name: index_assets_on_attachable; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_assets_on_attachable ON public.assets USING btree (attachable_type, attachable_id);


--
-- Name: index_assets_on_attachable_id_and_attachable_type_and_position; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_assets_on_attachable_id_and_attachable_type_and_position ON public.assets USING btree (attachable_id, attachable_type, "position");


--
-- Name: index_assets_on_attachment_data; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_assets_on_attachment_data ON public.assets USING gin (attachment_data);


--
-- Name: index_assets_on_collection_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_assets_on_collection_id ON public.assets USING btree (collection_id);


--
-- Name: index_assets_on_community_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_assets_on_community_id ON public.assets USING btree (community_id);


--
-- Name: index_assets_on_file_size; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_assets_on_file_size ON public.assets USING btree (file_size);


--
-- Name: index_assets_on_item_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_assets_on_item_id ON public.assets USING btree (item_id);


--
-- Name: index_assets_on_kind; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_assets_on_kind ON public.assets USING btree (kind);


--
-- Name: index_assets_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_assets_on_name ON public.assets USING btree (name);


--
-- Name: index_assets_on_parent_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_assets_on_parent_id ON public.assets USING btree (parent_id);


--
-- Name: index_assets_on_parent_id_and_position; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_assets_on_parent_id_and_position ON public.assets USING btree (parent_id, "position");


--
-- Name: index_assets_on_preview_data; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_assets_on_preview_data ON public.assets USING gin (preview_data);


--
-- Name: index_authorizing_entities_for_collections; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_authorizing_entities_for_collections ON public.authorizing_entities USING btree (hierarchical_id, hierarchical_type, auth_path, scope) WHERE (hierarchical_type = 'Collection'::text);


--
-- Name: index_authorizing_entities_for_items; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_authorizing_entities_for_items ON public.authorizing_entities USING btree (hierarchical_id, hierarchical_type, auth_path, scope) WHERE (hierarchical_type = 'Item'::text);


--
-- Name: index_authorizing_entities_for_single_join; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_authorizing_entities_for_single_join ON public.authorizing_entities USING btree (scope, auth_path, hierarchical_id, hierarchical_type);


--
-- Name: index_authorizing_entities_match_scope; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_authorizing_entities_match_scope ON public.authorizing_entities USING btree (hierarchical_id, hierarchical_type, auth_path, scope);


--
-- Name: index_authorizing_entities_on_auth_path_btree; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_authorizing_entities_on_auth_path_btree ON public.authorizing_entities USING btree (auth_path);


--
-- Name: index_authorizing_entities_on_entity_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_authorizing_entities_on_entity_id ON public.authorizing_entities USING btree (entity_id);


--
-- Name: index_authorizing_entities_on_hierarchical; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_authorizing_entities_on_hierarchical ON public.authorizing_entities USING btree (hierarchical_type, hierarchical_id);


--
-- Name: index_authorizing_entities_single_user; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_authorizing_entities_single_user ON public.authorizing_entities USING btree (auth_path, scope) INCLUDE (hierarchical_id, hierarchical_type);


--
-- Name: index_collection_authorizations_on_auth_path; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_collection_authorizations_on_auth_path ON public.collection_authorizations USING gist (auth_path);


--
-- Name: index_collection_authorizations_on_collection_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_collection_authorizations_on_collection_id ON public.collection_authorizations USING btree (collection_id);


--
-- Name: index_collection_authorizations_on_community_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_collection_authorizations_on_community_id ON public.collection_authorizations USING btree (community_id);


--
-- Name: index_collection_contributions_on_collection_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_collection_contributions_on_collection_id ON public.collection_contributions USING btree (collection_id);


--
-- Name: index_collection_contributions_on_contributor_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_collection_contributions_on_contributor_id ON public.collection_contributions USING btree (contributor_id);


--
-- Name: index_collection_contributions_uniqueness; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_collection_contributions_uniqueness ON public.collection_contributions USING btree (contributor_id, collection_id);


--
-- Name: index_collection_linked_items_on_source_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_collection_linked_items_on_source_id ON public.collection_linked_items USING btree (source_id);


--
-- Name: index_collection_linked_items_on_target_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_collection_linked_items_on_target_id ON public.collection_linked_items USING btree (target_id);


--
-- Name: index_collection_linked_items_uniqueness; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_collection_linked_items_uniqueness ON public.collection_linked_items USING btree (source_id, target_id);


--
-- Name: index_collection_links_on_source_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_collection_links_on_source_id ON public.collection_links USING btree (source_id);


--
-- Name: index_collection_links_on_target_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_collection_links_on_target_id ON public.collection_links USING btree (target_id);


--
-- Name: index_collection_links_uniqueness; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_collection_links_uniqueness ON public.collection_links USING btree (source_id, target_id);


--
-- Name: index_collections_on_auth_path; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_collections_on_auth_path ON public.collections USING gist (auth_path);


--
-- Name: index_collections_on_community_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_collections_on_community_id ON public.collections USING btree (community_id);


--
-- Name: index_collections_on_doi; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_collections_on_doi ON public.collections USING btree (doi);


--
-- Name: index_collections_on_parent_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_collections_on_parent_id ON public.collections USING btree (parent_id);


--
-- Name: index_collections_on_properties; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_collections_on_properties ON public.collections USING gin (properties);


--
-- Name: index_collections_on_published_on; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_collections_on_published_on ON public.collections USING btree (published_on);


--
-- Name: index_collections_on_schema_definition_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_collections_on_schema_definition_id ON public.collections USING btree (schema_definition_id);


--
-- Name: index_collections_on_schema_version_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_collections_on_schema_version_id ON public.collections USING btree (schema_version_id);


--
-- Name: index_collections_on_system_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_collections_on_system_slug ON public.collections USING btree (system_slug);


--
-- Name: index_collections_on_visible_after_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_collections_on_visible_after_at ON public.collections USING btree (visible_after_at);


--
-- Name: index_collections_unique_identifier; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_collections_unique_identifier ON public.collections USING btree (identifier, community_id, parent_id);


--
-- Name: index_collections_visibility_coverage; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_collections_visibility_coverage ON public.collections USING gist (visibility, visibility_range);


--
-- Name: index_communities_on_auth_path; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_communities_on_auth_path ON public.communities USING gist (auth_path);


--
-- Name: index_communities_on_position; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_communities_on_position ON public.communities USING btree ("position");


--
-- Name: index_communities_on_schema_definition_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_communities_on_schema_definition_id ON public.communities USING btree (schema_definition_id);


--
-- Name: index_communities_on_schema_version_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_communities_on_schema_version_id ON public.communities USING btree (schema_version_id);


--
-- Name: index_communities_on_system_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_communities_on_system_slug ON public.communities USING btree (system_slug);


--
-- Name: index_community_memberships_on_community_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_community_memberships_on_community_id ON public.community_memberships USING btree (community_id);


--
-- Name: index_community_memberships_on_role_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_community_memberships_on_role_id ON public.community_memberships USING btree (role_id);


--
-- Name: index_community_memberships_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_community_memberships_on_user_id ON public.community_memberships USING btree (user_id);


--
-- Name: index_community_memberships_uniqueness; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_community_memberships_uniqueness ON public.community_memberships USING btree (community_id, user_id);


--
-- Name: index_entities_crumb_source; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_entities_crumb_source ON public.entities USING gist (depth, auth_path, entity_id, entity_type, system_slug);


--
-- Name: index_entities_crumb_target; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_entities_crumb_target ON public.entities USING btree (auth_path, entity_id, entity_type, system_slug);


--
-- Name: index_entities_hierarchical_permission_matching; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_entities_hierarchical_permission_matching ON public.entities USING btree (hierarchical_id, hierarchical_type) INCLUDE (auth_path, scope);


--
-- Name: index_entities_on_auth_path; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_entities_on_auth_path ON public.entities USING gist (auth_path);


--
-- Name: index_entities_on_auth_path_btree; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_entities_on_auth_path_btree ON public.entities USING btree (auth_path);


--
-- Name: index_entities_on_entity; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_entities_on_entity ON public.entities USING btree (entity_type, entity_id);


--
-- Name: index_entities_on_hierarchical; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_entities_on_hierarchical ON public.entities USING btree (hierarchical_type, hierarchical_id);


--
-- Name: index_entities_on_link_operator; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_entities_on_link_operator ON public.entities USING btree (link_operator);


--
-- Name: index_entities_on_schema_version_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_entities_on_schema_version_id ON public.entities USING btree (schema_version_id);


--
-- Name: index_entities_on_system_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_entities_on_system_slug ON public.entities USING btree (system_slug);


--
-- Name: index_entities_permissions_calculation; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_entities_permissions_calculation ON public.entities USING gist (hierarchical_type, hierarchical_id, auth_path, scope);


--
-- Name: index_entity_links_on_auth_path; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_entity_links_on_auth_path ON public.entity_links USING gist (auth_path);


--
-- Name: index_entity_links_on_schema_version_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_entity_links_on_schema_version_id ON public.entity_links USING btree (schema_version_id);


--
-- Name: index_entity_links_on_scope; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_entity_links_on_scope ON public.entity_links USING gist (scope);


--
-- Name: index_entity_links_on_source; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_entity_links_on_source ON public.entity_links USING btree (source_type, source_id);


--
-- Name: index_entity_links_on_source_collection_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_entity_links_on_source_collection_id ON public.entity_links USING btree (source_collection_id);


--
-- Name: index_entity_links_on_source_community_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_entity_links_on_source_community_id ON public.entity_links USING btree (source_community_id);


--
-- Name: index_entity_links_on_source_item_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_entity_links_on_source_item_id ON public.entity_links USING btree (source_item_id);


--
-- Name: index_entity_links_on_system_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_entity_links_on_system_slug ON public.entity_links USING btree (system_slug);


--
-- Name: index_entity_links_on_target; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_entity_links_on_target ON public.entity_links USING btree (target_type, target_id);


--
-- Name: index_entity_links_on_target_collection_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_entity_links_on_target_collection_id ON public.entity_links USING btree (target_collection_id);


--
-- Name: index_entity_links_on_target_community_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_entity_links_on_target_community_id ON public.entity_links USING btree (target_community_id);


--
-- Name: index_entity_links_on_target_item_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_entity_links_on_target_item_id ON public.entity_links USING btree (target_item_id);


--
-- Name: index_entity_links_uniqueness; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_entity_links_uniqueness ON public.entity_links USING btree (source_type, source_id, target_type, target_id);


--
-- Name: index_granted_permissions_by_role_permission; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_granted_permissions_by_role_permission ON public.granted_permissions USING btree (role_id, permission_id);


--
-- Name: index_granted_permissions_contextual_btree; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_granted_permissions_contextual_btree ON public.granted_permissions USING btree (scope, auth_path, user_id, permission_id, action, inferred, role_id, accessible_id, accessible_type, access_grant_id);


--
-- Name: index_granted_permissions_contextual_user; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_granted_permissions_contextual_user ON public.granted_permissions USING btree (user_id, permission_id, scope, auth_path, action, inferred, role_id, accessible_id, accessible_type, access_grant_id);


--
-- Name: index_granted_permissions_on_access_grant_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_granted_permissions_on_access_grant_id ON public.granted_permissions USING btree (access_grant_id);


--
-- Name: index_granted_permissions_on_accessible; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_granted_permissions_on_accessible ON public.granted_permissions USING btree (accessible_type, accessible_id);


--
-- Name: index_granted_permissions_on_inferred; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_granted_permissions_on_inferred ON public.granted_permissions USING btree (inferred);


--
-- Name: index_granted_permissions_on_permission_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_granted_permissions_on_permission_id ON public.granted_permissions USING btree (permission_id);


--
-- Name: index_granted_permissions_on_role_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_granted_permissions_on_role_id ON public.granted_permissions USING btree (role_id);


--
-- Name: index_granted_permissions_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_granted_permissions_on_user_id ON public.granted_permissions USING btree (user_id);


--
-- Name: index_granted_permissions_uniqueness; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_granted_permissions_uniqueness ON public.granted_permissions USING btree (access_grant_id, permission_id, user_id, scope, action);


--
-- Name: index_item_authorizations_on_auth_path; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_item_authorizations_on_auth_path ON public.item_authorizations USING gist (auth_path);


--
-- Name: index_item_authorizations_on_collection_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_item_authorizations_on_collection_id ON public.item_authorizations USING btree (collection_id);


--
-- Name: index_item_authorizations_on_community_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_item_authorizations_on_community_id ON public.item_authorizations USING btree (community_id);


--
-- Name: index_item_authorizations_on_item_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_item_authorizations_on_item_id ON public.item_authorizations USING btree (item_id);


--
-- Name: index_item_contributions_on_contributor_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_item_contributions_on_contributor_id ON public.item_contributions USING btree (contributor_id);


--
-- Name: index_item_contributions_on_item_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_item_contributions_on_item_id ON public.item_contributions USING btree (item_id);


--
-- Name: index_item_contributions_uniqueness; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_item_contributions_uniqueness ON public.item_contributions USING btree (contributor_id, item_id);


--
-- Name: index_item_links_on_source_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_item_links_on_source_id ON public.item_links USING btree (source_id);


--
-- Name: index_item_links_on_target_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_item_links_on_target_id ON public.item_links USING btree (target_id);


--
-- Name: index_item_links_uniqueness; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_item_links_uniqueness ON public.item_links USING btree (source_id, target_id);


--
-- Name: index_items_on_auth_path; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_items_on_auth_path ON public.items USING gist (auth_path);


--
-- Name: index_items_on_collection_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_items_on_collection_id ON public.items USING btree (collection_id);


--
-- Name: index_items_on_doi; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_items_on_doi ON public.items USING btree (doi);


--
-- Name: index_items_on_parent_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_items_on_parent_id ON public.items USING btree (parent_id);


--
-- Name: index_items_on_properties; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_items_on_properties ON public.items USING gin (properties);


--
-- Name: index_items_on_published_on; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_items_on_published_on ON public.items USING btree (published_on);


--
-- Name: index_items_on_schema_definition_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_items_on_schema_definition_id ON public.items USING btree (schema_definition_id);


--
-- Name: index_items_on_schema_version_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_items_on_schema_version_id ON public.items USING btree (schema_version_id);


--
-- Name: index_items_on_system_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_items_on_system_slug ON public.items USING btree (system_slug);


--
-- Name: index_items_on_visible_after_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_items_on_visible_after_at ON public.items USING btree (visible_after_at);


--
-- Name: index_items_unique_identifier; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_items_unique_identifier ON public.items USING btree (identifier, collection_id, parent_id);


--
-- Name: index_items_visibility_coverage; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_items_visibility_coverage ON public.items USING gist (visibility, visibility_range);


--
-- Name: index_ordering_entries_on_ordering_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ordering_entries_on_ordering_id ON ONLY public.ordering_entries USING btree (ordering_id);


--
-- Name: index_ordering_entries_references_entity; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ordering_entries_references_entity ON ONLY public.ordering_entries USING btree (entity_type, entity_id);


--
-- Name: index_ordering_entries_sort; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ordering_entries_sort ON ONLY public.ordering_entries USING btree (ordering_id, "position");


--
-- Name: index_ordering_entries_sorted_by_scope; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ordering_entries_sorted_by_scope ON ONLY public.ordering_entries USING gist (ordering_id, scope, "position");


--
-- Name: index_ordering_entries_uniqueness; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_ordering_entries_uniqueness ON ONLY public.ordering_entries USING btree (ordering_id, entity_type, entity_id);


--
-- Name: index_orderings_enabled_by_entity; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_orderings_enabled_by_entity ON public.orderings USING btree (entity_id, entity_type) WHERE (disabled_at IS NULL);


--
-- Name: index_orderings_on_collection_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_orderings_on_collection_id ON public.orderings USING btree (collection_id);


--
-- Name: index_orderings_on_community_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_orderings_on_community_id ON public.orderings USING btree (community_id);


--
-- Name: index_orderings_on_entity; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_orderings_on_entity ON public.orderings USING btree (entity_type, entity_id);


--
-- Name: index_orderings_on_item_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_orderings_on_item_id ON public.orderings USING btree (item_id);


--
-- Name: index_orderings_on_schema_version_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_orderings_on_schema_version_id ON public.orderings USING btree (schema_version_id);


--
-- Name: index_orderings_uniqueness; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_orderings_uniqueness ON public.orderings USING btree (entity_id, entity_type, identifier);


--
-- Name: index_permissions_contextual_derivations; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_permissions_contextual_derivations ON public.permissions USING btree (name, scope, path) WHERE (kind = 'contextual'::public.permission_kind);


--
-- Name: index_permissions_inherited; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_permissions_inherited ON public.permissions USING btree (id, path, inheritance);


--
-- Name: index_permissions_name_text; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_permissions_name_text ON public.permissions USING btree (((name)::text));


--
-- Name: index_permissions_on_inheritance; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_permissions_on_inheritance ON public.permissions USING gist (inheritance);


--
-- Name: index_permissions_on_kind; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_permissions_on_kind ON public.permissions USING btree (kind);


--
-- Name: index_permissions_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_permissions_on_name ON public.permissions USING btree (name);


--
-- Name: index_permissions_on_scope; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_permissions_on_scope ON public.permissions USING btree (scope);


--
-- Name: index_permissions_uniqueness; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_permissions_uniqueness ON public.permissions USING btree (path);


--
-- Name: index_role_permissions_on_permission_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_role_permissions_on_permission_id ON public.role_permissions USING btree (permission_id);


--
-- Name: index_role_permissions_on_role_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_role_permissions_on_role_id ON public.role_permissions USING btree (role_id);


--
-- Name: index_roles_on_allowed_actions; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_roles_on_allowed_actions ON public.roles USING gist (allowed_actions);


--
-- Name: index_roles_on_system_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_roles_on_system_slug ON public.roles USING btree (system_slug);


--
-- Name: index_roles_unique_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_roles_unique_name ON public.roles USING btree (name);


--
-- Name: index_schema_definitions_on_namespace; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_schema_definitions_on_namespace ON public.schema_definitions USING btree (namespace);


--
-- Name: index_schema_definitions_on_system_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_schema_definitions_on_system_slug ON public.schema_definitions USING btree (system_slug);


--
-- Name: index_schema_definitions_uniqueness; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_schema_definitions_uniqueness ON public.schema_definitions USING btree (identifier, namespace);


--
-- Name: index_schema_versions_current; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_schema_versions_current ON public.schema_versions USING btree (schema_definition_id, current) WHERE current;


--
-- Name: index_schema_versions_on_schema_definition_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_schema_versions_on_schema_definition_id ON public.schema_versions USING btree (schema_definition_id);


--
-- Name: index_schema_versions_on_schema_definition_id_and_position; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_schema_versions_on_schema_definition_id_and_position ON public.schema_versions USING btree (schema_definition_id, "position");


--
-- Name: index_schema_versions_on_system_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_schema_versions_on_system_slug ON public.schema_versions USING btree (system_slug);


--
-- Name: index_schema_versions_uniqueness; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_schema_versions_uniqueness ON public.schema_versions USING btree (schema_definition_id, number);


--
-- Name: index_schematic_collected_references_on_referent; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_schematic_collected_references_on_referent ON public.schematic_collected_references USING btree (referent_type, referent_id);


--
-- Name: index_schematic_collected_references_on_referrer; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_schematic_collected_references_on_referrer ON public.schematic_collected_references USING btree (referrer_type, referrer_id);


--
-- Name: index_schematic_collected_references_ordering; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_schematic_collected_references_ordering ON public.schematic_collected_references USING btree (referrer_type, referrer_id, path, "position");


--
-- Name: index_schematic_collected_references_uniqueness; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_schematic_collected_references_uniqueness ON public.schematic_collected_references USING btree (referrer_type, referrer_id, referent_type, referent_id, path);


--
-- Name: index_schematic_scalar_references_on_referent; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_schematic_scalar_references_on_referent ON public.schematic_scalar_references USING btree (referent_type, referent_id);


--
-- Name: index_schematic_scalar_references_on_referrer; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_schematic_scalar_references_on_referrer ON public.schematic_scalar_references USING btree (referrer_type, referrer_id);


--
-- Name: index_schematic_scalar_references_uniqueness; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_schematic_scalar_references_uniqueness ON public.schematic_scalar_references USING btree (referrer_type, referrer_id, path);


--
-- Name: index_user_group_memberships_on_user_group_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_user_group_memberships_on_user_group_id ON public.user_group_memberships USING btree (user_group_id);


--
-- Name: index_user_group_memberships_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_user_group_memberships_on_user_id ON public.user_group_memberships USING btree (user_id);


--
-- Name: index_user_group_memberships_uniqueness; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_user_group_memberships_uniqueness ON public.user_group_memberships USING btree (user_id, user_group_id);


--
-- Name: index_user_groups_on_keycloak_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_user_groups_on_keycloak_id ON public.user_groups USING btree (keycloak_id);


--
-- Name: index_user_groups_on_system_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_user_groups_on_system_slug ON public.user_groups USING btree (system_slug);


--
-- Name: index_users_on_allowed_actions; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_allowed_actions ON public.users USING gist (allowed_actions);


--
-- Name: index_users_on_global_access_control_list; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_global_access_control_list ON public.users USING gin (global_access_control_list);


--
-- Name: index_users_on_keycloak_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_keycloak_id ON public.users USING btree (keycloak_id);


--
-- Name: index_users_on_system_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_system_slug ON public.users USING btree (system_slug);


--
-- Name: item_anc_desc_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX item_anc_desc_idx ON public.item_hierarchies USING btree (ancestor_id, descendant_id, generations);


--
-- Name: item_desc_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX item_desc_idx ON public.item_hierarchies USING btree (descendant_id);


--
-- Name: ordering_entries_part_1_entity_type_entity_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ordering_entries_part_1_entity_type_entity_id_idx ON public.ordering_entries_part_1 USING btree (entity_type, entity_id);


--
-- Name: ordering_entries_part_1_ordering_id_entity_type_entity_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX ordering_entries_part_1_ordering_id_entity_type_entity_id_idx ON public.ordering_entries_part_1 USING btree (ordering_id, entity_type, entity_id);


--
-- Name: ordering_entries_part_1_ordering_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ordering_entries_part_1_ordering_id_idx ON public.ordering_entries_part_1 USING btree (ordering_id);


--
-- Name: ordering_entries_part_1_ordering_id_position_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ordering_entries_part_1_ordering_id_position_idx ON public.ordering_entries_part_1 USING btree (ordering_id, "position");


--
-- Name: ordering_entries_part_1_ordering_id_scope_position_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ordering_entries_part_1_ordering_id_scope_position_idx ON public.ordering_entries_part_1 USING gist (ordering_id, scope, "position");


--
-- Name: ordering_entries_part_2_entity_type_entity_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ordering_entries_part_2_entity_type_entity_id_idx ON public.ordering_entries_part_2 USING btree (entity_type, entity_id);


--
-- Name: ordering_entries_part_2_ordering_id_entity_type_entity_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX ordering_entries_part_2_ordering_id_entity_type_entity_id_idx ON public.ordering_entries_part_2 USING btree (ordering_id, entity_type, entity_id);


--
-- Name: ordering_entries_part_2_ordering_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ordering_entries_part_2_ordering_id_idx ON public.ordering_entries_part_2 USING btree (ordering_id);


--
-- Name: ordering_entries_part_2_ordering_id_position_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ordering_entries_part_2_ordering_id_position_idx ON public.ordering_entries_part_2 USING btree (ordering_id, "position");


--
-- Name: ordering_entries_part_2_ordering_id_scope_position_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ordering_entries_part_2_ordering_id_scope_position_idx ON public.ordering_entries_part_2 USING gist (ordering_id, scope, "position");


--
-- Name: ordering_entries_part_3_entity_type_entity_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ordering_entries_part_3_entity_type_entity_id_idx ON public.ordering_entries_part_3 USING btree (entity_type, entity_id);


--
-- Name: ordering_entries_part_3_ordering_id_entity_type_entity_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX ordering_entries_part_3_ordering_id_entity_type_entity_id_idx ON public.ordering_entries_part_3 USING btree (ordering_id, entity_type, entity_id);


--
-- Name: ordering_entries_part_3_ordering_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ordering_entries_part_3_ordering_id_idx ON public.ordering_entries_part_3 USING btree (ordering_id);


--
-- Name: ordering_entries_part_3_ordering_id_position_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ordering_entries_part_3_ordering_id_position_idx ON public.ordering_entries_part_3 USING btree (ordering_id, "position");


--
-- Name: ordering_entries_part_3_ordering_id_scope_position_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ordering_entries_part_3_ordering_id_scope_position_idx ON public.ordering_entries_part_3 USING gist (ordering_id, scope, "position");


--
-- Name: ordering_entries_part_4_entity_type_entity_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ordering_entries_part_4_entity_type_entity_id_idx ON public.ordering_entries_part_4 USING btree (entity_type, entity_id);


--
-- Name: ordering_entries_part_4_ordering_id_entity_type_entity_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX ordering_entries_part_4_ordering_id_entity_type_entity_id_idx ON public.ordering_entries_part_4 USING btree (ordering_id, entity_type, entity_id);


--
-- Name: ordering_entries_part_4_ordering_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ordering_entries_part_4_ordering_id_idx ON public.ordering_entries_part_4 USING btree (ordering_id);


--
-- Name: ordering_entries_part_4_ordering_id_position_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ordering_entries_part_4_ordering_id_position_idx ON public.ordering_entries_part_4 USING btree (ordering_id, "position");


--
-- Name: ordering_entries_part_4_ordering_id_scope_position_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ordering_entries_part_4_ordering_id_scope_position_idx ON public.ordering_entries_part_4 USING gist (ordering_id, scope, "position");


--
-- Name: ordering_entries_part_5_entity_type_entity_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ordering_entries_part_5_entity_type_entity_id_idx ON public.ordering_entries_part_5 USING btree (entity_type, entity_id);


--
-- Name: ordering_entries_part_5_ordering_id_entity_type_entity_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX ordering_entries_part_5_ordering_id_entity_type_entity_id_idx ON public.ordering_entries_part_5 USING btree (ordering_id, entity_type, entity_id);


--
-- Name: ordering_entries_part_5_ordering_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ordering_entries_part_5_ordering_id_idx ON public.ordering_entries_part_5 USING btree (ordering_id);


--
-- Name: ordering_entries_part_5_ordering_id_position_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ordering_entries_part_5_ordering_id_position_idx ON public.ordering_entries_part_5 USING btree (ordering_id, "position");


--
-- Name: ordering_entries_part_5_ordering_id_scope_position_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ordering_entries_part_5_ordering_id_scope_position_idx ON public.ordering_entries_part_5 USING gist (ordering_id, scope, "position");


--
-- Name: ordering_entries_part_6_entity_type_entity_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ordering_entries_part_6_entity_type_entity_id_idx ON public.ordering_entries_part_6 USING btree (entity_type, entity_id);


--
-- Name: ordering_entries_part_6_ordering_id_entity_type_entity_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX ordering_entries_part_6_ordering_id_entity_type_entity_id_idx ON public.ordering_entries_part_6 USING btree (ordering_id, entity_type, entity_id);


--
-- Name: ordering_entries_part_6_ordering_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ordering_entries_part_6_ordering_id_idx ON public.ordering_entries_part_6 USING btree (ordering_id);


--
-- Name: ordering_entries_part_6_ordering_id_position_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ordering_entries_part_6_ordering_id_position_idx ON public.ordering_entries_part_6 USING btree (ordering_id, "position");


--
-- Name: ordering_entries_part_6_ordering_id_scope_position_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ordering_entries_part_6_ordering_id_scope_position_idx ON public.ordering_entries_part_6 USING gist (ordering_id, scope, "position");


--
-- Name: ordering_entries_part_7_entity_type_entity_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ordering_entries_part_7_entity_type_entity_id_idx ON public.ordering_entries_part_7 USING btree (entity_type, entity_id);


--
-- Name: ordering_entries_part_7_ordering_id_entity_type_entity_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX ordering_entries_part_7_ordering_id_entity_type_entity_id_idx ON public.ordering_entries_part_7 USING btree (ordering_id, entity_type, entity_id);


--
-- Name: ordering_entries_part_7_ordering_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ordering_entries_part_7_ordering_id_idx ON public.ordering_entries_part_7 USING btree (ordering_id);


--
-- Name: ordering_entries_part_7_ordering_id_position_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ordering_entries_part_7_ordering_id_position_idx ON public.ordering_entries_part_7 USING btree (ordering_id, "position");


--
-- Name: ordering_entries_part_7_ordering_id_scope_position_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ordering_entries_part_7_ordering_id_scope_position_idx ON public.ordering_entries_part_7 USING gist (ordering_id, scope, "position");


--
-- Name: ordering_entries_part_8_entity_type_entity_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ordering_entries_part_8_entity_type_entity_id_idx ON public.ordering_entries_part_8 USING btree (entity_type, entity_id);


--
-- Name: ordering_entries_part_8_ordering_id_entity_type_entity_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX ordering_entries_part_8_ordering_id_entity_type_entity_id_idx ON public.ordering_entries_part_8 USING btree (ordering_id, entity_type, entity_id);


--
-- Name: ordering_entries_part_8_ordering_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ordering_entries_part_8_ordering_id_idx ON public.ordering_entries_part_8 USING btree (ordering_id);


--
-- Name: ordering_entries_part_8_ordering_id_position_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ordering_entries_part_8_ordering_id_position_idx ON public.ordering_entries_part_8 USING btree (ordering_id, "position");


--
-- Name: ordering_entries_part_8_ordering_id_scope_position_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ordering_entries_part_8_ordering_id_scope_position_idx ON public.ordering_entries_part_8 USING gist (ordering_id, scope, "position");


--
-- Name: role_permissions_context; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX role_permissions_context ON public.role_permissions USING btree (role_id, permission_id, inferred, action, inferring_scopes);


--
-- Name: role_permissions_uniqueness; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX role_permissions_uniqueness ON public.role_permissions USING btree (role_id, permission_id) INCLUDE (inferred, inferring_scopes, inferring_actions);


--
-- Name: ordering_entries_part_1_entity_type_entity_id_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_ordering_entries_references_entity ATTACH PARTITION public.ordering_entries_part_1_entity_type_entity_id_idx;


--
-- Name: ordering_entries_part_1_ordering_id_entity_type_entity_id_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_ordering_entries_uniqueness ATTACH PARTITION public.ordering_entries_part_1_ordering_id_entity_type_entity_id_idx;


--
-- Name: ordering_entries_part_1_ordering_id_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_ordering_entries_on_ordering_id ATTACH PARTITION public.ordering_entries_part_1_ordering_id_idx;


--
-- Name: ordering_entries_part_1_ordering_id_position_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_ordering_entries_sort ATTACH PARTITION public.ordering_entries_part_1_ordering_id_position_idx;


--
-- Name: ordering_entries_part_1_ordering_id_scope_position_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_ordering_entries_sorted_by_scope ATTACH PARTITION public.ordering_entries_part_1_ordering_id_scope_position_idx;


--
-- Name: ordering_entries_part_1_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.ordering_entries_pkey ATTACH PARTITION public.ordering_entries_part_1_pkey;


--
-- Name: ordering_entries_part_2_entity_type_entity_id_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_ordering_entries_references_entity ATTACH PARTITION public.ordering_entries_part_2_entity_type_entity_id_idx;


--
-- Name: ordering_entries_part_2_ordering_id_entity_type_entity_id_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_ordering_entries_uniqueness ATTACH PARTITION public.ordering_entries_part_2_ordering_id_entity_type_entity_id_idx;


--
-- Name: ordering_entries_part_2_ordering_id_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_ordering_entries_on_ordering_id ATTACH PARTITION public.ordering_entries_part_2_ordering_id_idx;


--
-- Name: ordering_entries_part_2_ordering_id_position_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_ordering_entries_sort ATTACH PARTITION public.ordering_entries_part_2_ordering_id_position_idx;


--
-- Name: ordering_entries_part_2_ordering_id_scope_position_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_ordering_entries_sorted_by_scope ATTACH PARTITION public.ordering_entries_part_2_ordering_id_scope_position_idx;


--
-- Name: ordering_entries_part_2_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.ordering_entries_pkey ATTACH PARTITION public.ordering_entries_part_2_pkey;


--
-- Name: ordering_entries_part_3_entity_type_entity_id_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_ordering_entries_references_entity ATTACH PARTITION public.ordering_entries_part_3_entity_type_entity_id_idx;


--
-- Name: ordering_entries_part_3_ordering_id_entity_type_entity_id_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_ordering_entries_uniqueness ATTACH PARTITION public.ordering_entries_part_3_ordering_id_entity_type_entity_id_idx;


--
-- Name: ordering_entries_part_3_ordering_id_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_ordering_entries_on_ordering_id ATTACH PARTITION public.ordering_entries_part_3_ordering_id_idx;


--
-- Name: ordering_entries_part_3_ordering_id_position_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_ordering_entries_sort ATTACH PARTITION public.ordering_entries_part_3_ordering_id_position_idx;


--
-- Name: ordering_entries_part_3_ordering_id_scope_position_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_ordering_entries_sorted_by_scope ATTACH PARTITION public.ordering_entries_part_3_ordering_id_scope_position_idx;


--
-- Name: ordering_entries_part_3_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.ordering_entries_pkey ATTACH PARTITION public.ordering_entries_part_3_pkey;


--
-- Name: ordering_entries_part_4_entity_type_entity_id_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_ordering_entries_references_entity ATTACH PARTITION public.ordering_entries_part_4_entity_type_entity_id_idx;


--
-- Name: ordering_entries_part_4_ordering_id_entity_type_entity_id_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_ordering_entries_uniqueness ATTACH PARTITION public.ordering_entries_part_4_ordering_id_entity_type_entity_id_idx;


--
-- Name: ordering_entries_part_4_ordering_id_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_ordering_entries_on_ordering_id ATTACH PARTITION public.ordering_entries_part_4_ordering_id_idx;


--
-- Name: ordering_entries_part_4_ordering_id_position_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_ordering_entries_sort ATTACH PARTITION public.ordering_entries_part_4_ordering_id_position_idx;


--
-- Name: ordering_entries_part_4_ordering_id_scope_position_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_ordering_entries_sorted_by_scope ATTACH PARTITION public.ordering_entries_part_4_ordering_id_scope_position_idx;


--
-- Name: ordering_entries_part_4_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.ordering_entries_pkey ATTACH PARTITION public.ordering_entries_part_4_pkey;


--
-- Name: ordering_entries_part_5_entity_type_entity_id_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_ordering_entries_references_entity ATTACH PARTITION public.ordering_entries_part_5_entity_type_entity_id_idx;


--
-- Name: ordering_entries_part_5_ordering_id_entity_type_entity_id_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_ordering_entries_uniqueness ATTACH PARTITION public.ordering_entries_part_5_ordering_id_entity_type_entity_id_idx;


--
-- Name: ordering_entries_part_5_ordering_id_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_ordering_entries_on_ordering_id ATTACH PARTITION public.ordering_entries_part_5_ordering_id_idx;


--
-- Name: ordering_entries_part_5_ordering_id_position_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_ordering_entries_sort ATTACH PARTITION public.ordering_entries_part_5_ordering_id_position_idx;


--
-- Name: ordering_entries_part_5_ordering_id_scope_position_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_ordering_entries_sorted_by_scope ATTACH PARTITION public.ordering_entries_part_5_ordering_id_scope_position_idx;


--
-- Name: ordering_entries_part_5_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.ordering_entries_pkey ATTACH PARTITION public.ordering_entries_part_5_pkey;


--
-- Name: ordering_entries_part_6_entity_type_entity_id_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_ordering_entries_references_entity ATTACH PARTITION public.ordering_entries_part_6_entity_type_entity_id_idx;


--
-- Name: ordering_entries_part_6_ordering_id_entity_type_entity_id_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_ordering_entries_uniqueness ATTACH PARTITION public.ordering_entries_part_6_ordering_id_entity_type_entity_id_idx;


--
-- Name: ordering_entries_part_6_ordering_id_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_ordering_entries_on_ordering_id ATTACH PARTITION public.ordering_entries_part_6_ordering_id_idx;


--
-- Name: ordering_entries_part_6_ordering_id_position_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_ordering_entries_sort ATTACH PARTITION public.ordering_entries_part_6_ordering_id_position_idx;


--
-- Name: ordering_entries_part_6_ordering_id_scope_position_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_ordering_entries_sorted_by_scope ATTACH PARTITION public.ordering_entries_part_6_ordering_id_scope_position_idx;


--
-- Name: ordering_entries_part_6_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.ordering_entries_pkey ATTACH PARTITION public.ordering_entries_part_6_pkey;


--
-- Name: ordering_entries_part_7_entity_type_entity_id_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_ordering_entries_references_entity ATTACH PARTITION public.ordering_entries_part_7_entity_type_entity_id_idx;


--
-- Name: ordering_entries_part_7_ordering_id_entity_type_entity_id_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_ordering_entries_uniqueness ATTACH PARTITION public.ordering_entries_part_7_ordering_id_entity_type_entity_id_idx;


--
-- Name: ordering_entries_part_7_ordering_id_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_ordering_entries_on_ordering_id ATTACH PARTITION public.ordering_entries_part_7_ordering_id_idx;


--
-- Name: ordering_entries_part_7_ordering_id_position_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_ordering_entries_sort ATTACH PARTITION public.ordering_entries_part_7_ordering_id_position_idx;


--
-- Name: ordering_entries_part_7_ordering_id_scope_position_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_ordering_entries_sorted_by_scope ATTACH PARTITION public.ordering_entries_part_7_ordering_id_scope_position_idx;


--
-- Name: ordering_entries_part_7_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.ordering_entries_pkey ATTACH PARTITION public.ordering_entries_part_7_pkey;


--
-- Name: ordering_entries_part_8_entity_type_entity_id_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_ordering_entries_references_entity ATTACH PARTITION public.ordering_entries_part_8_entity_type_entity_id_idx;


--
-- Name: ordering_entries_part_8_ordering_id_entity_type_entity_id_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_ordering_entries_uniqueness ATTACH PARTITION public.ordering_entries_part_8_ordering_id_entity_type_entity_id_idx;


--
-- Name: ordering_entries_part_8_ordering_id_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_ordering_entries_on_ordering_id ATTACH PARTITION public.ordering_entries_part_8_ordering_id_idx;


--
-- Name: ordering_entries_part_8_ordering_id_position_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_ordering_entries_sort ATTACH PARTITION public.ordering_entries_part_8_ordering_id_position_idx;


--
-- Name: ordering_entries_part_8_ordering_id_scope_position_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_ordering_entries_sorted_by_scope ATTACH PARTITION public.ordering_entries_part_8_ordering_id_scope_position_idx;


--
-- Name: ordering_entries_part_8_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.ordering_entries_pkey ATTACH PARTITION public.ordering_entries_part_8_pkey;


--
-- Name: authorizing_entities_hierarchical_stats; Type: STATISTICS; Schema: public; Owner: -
--

CREATE STATISTICS public.authorizing_entities_hierarchical_stats ON auth_path, hierarchical_type, hierarchical_id FROM public.authorizing_entities;


--
-- Name: ent_hierarchical_stats; Type: STATISTICS; Schema: public; Owner: -
--

CREATE STATISTICS public.ent_hierarchical_stats ON hierarchical_type, hierarchical_id, auth_path, scope FROM public.entities;


--
-- Name: granted_permissions_rp_stats; Type: STATISTICS; Schema: public; Owner: -
--

CREATE STATISTICS public.granted_permissions_rp_stats ON permission_id, scope, action, role_id FROM public.granted_permissions;


--
-- Name: role_permissions_rp_stats; Type: STATISTICS; Schema: public; Owner: -
--

CREATE STATISTICS public.role_permissions_rp_stats ON permission_id, role_id FROM public.role_permissions;


--
-- Name: collection_linked_items fk_rails_08f9156aa0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.collection_linked_items
    ADD CONSTRAINT fk_rails_08f9156aa0 FOREIGN KEY (source_id) REFERENCES public.collections(id) ON DELETE RESTRICT;


--
-- Name: assets fk_rails_091f138553; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assets
    ADD CONSTRAINT fk_rails_091f138553 FOREIGN KEY (item_id) REFERENCES public.items(id) ON DELETE RESTRICT;


--
-- Name: collections fk_rails_1036c77f58; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.collections
    ADD CONSTRAINT fk_rails_1036c77f58 FOREIGN KEY (schema_definition_id) REFERENCES public.schema_definitions(id) ON DELETE RESTRICT;


--
-- Name: collection_links fk_rails_11a845b774; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.collection_links
    ADD CONSTRAINT fk_rails_11a845b774 FOREIGN KEY (target_id) REFERENCES public.collections(id) ON DELETE RESTRICT;


--
-- Name: items fk_rails_2a18ad62a0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.items
    ADD CONSTRAINT fk_rails_2a18ad62a0 FOREIGN KEY (collection_id) REFERENCES public.collections(id) ON DELETE RESTRICT;


--
-- Name: access_grants fk_rails_2a8d9374ca; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.access_grants
    ADD CONSTRAINT fk_rails_2a8d9374ca FOREIGN KEY (community_id) REFERENCES public.communities(id) ON DELETE CASCADE;


--
-- Name: community_memberships fk_rails_2acbed9229; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.community_memberships
    ADD CONSTRAINT fk_rails_2acbed9229 FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: items fk_rails_382f073cd8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.items
    ADD CONSTRAINT fk_rails_382f073cd8 FOREIGN KEY (schema_definition_id) REFERENCES public.schema_definitions(id) ON DELETE RESTRICT;


--
-- Name: orderings fk_rails_3a24b6bb35; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orderings
    ADD CONSTRAINT fk_rails_3a24b6bb35 FOREIGN KEY (item_id) REFERENCES public.items(id) ON DELETE CASCADE;


--
-- Name: collection_links fk_rails_3cc144ad4c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.collection_links
    ADD CONSTRAINT fk_rails_3cc144ad4c FOREIGN KEY (source_id) REFERENCES public.collections(id) ON DELETE RESTRICT;


--
-- Name: entities fk_rails_40b78347f2; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entities
    ADD CONSTRAINT fk_rails_40b78347f2 FOREIGN KEY (schema_version_id) REFERENCES public.schema_versions(id) ON DELETE RESTRICT;


--
-- Name: user_group_memberships fk_rails_42022c51df; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_group_memberships
    ADD CONSTRAINT fk_rails_42022c51df FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: role_permissions fk_rails_439e640a3f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT fk_rails_439e640a3f FOREIGN KEY (permission_id) REFERENCES public.permissions(id) ON DELETE CASCADE;


--
-- Name: access_grants fk_rails_45826fafdd; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.access_grants
    ADD CONSTRAINT fk_rails_45826fafdd FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE RESTRICT;


--
-- Name: granted_permissions fk_rails_461469ccc7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.granted_permissions
    ADD CONSTRAINT fk_rails_461469ccc7 FOREIGN KEY (access_grant_id) REFERENCES public.access_grants(id) ON DELETE CASCADE;


--
-- Name: access_grants fk_rails_4cf2824701; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.access_grants
    ADD CONSTRAINT fk_rails_4cf2824701 FOREIGN KEY (item_id) REFERENCES public.items(id) ON DELETE CASCADE;


--
-- Name: community_memberships fk_rails_5275a2ad88; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.community_memberships
    ADD CONSTRAINT fk_rails_5275a2ad88 FOREIGN KEY (community_id) REFERENCES public.communities(id) ON DELETE CASCADE;


--
-- Name: access_grants fk_rails_55410f2ab3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.access_grants
    ADD CONSTRAINT fk_rails_55410f2ab3 FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: role_permissions fk_rails_60126080bd; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT fk_rails_60126080bd FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE CASCADE;


--
-- Name: item_links fk_rails_67a3fd259e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.item_links
    ADD CONSTRAINT fk_rails_67a3fd259e FOREIGN KEY (target_id) REFERENCES public.items(id) ON DELETE RESTRICT;


--
-- Name: orderings fk_rails_6ac675728d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orderings
    ADD CONSTRAINT fk_rails_6ac675728d FOREIGN KEY (collection_id) REFERENCES public.collections(id) ON DELETE CASCADE;


--
-- Name: entity_links fk_rails_6ad35546ca; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entity_links
    ADD CONSTRAINT fk_rails_6ad35546ca FOREIGN KEY (schema_version_id) REFERENCES public.schema_versions(id) ON DELETE CASCADE;


--
-- Name: communities fk_rails_6beda9a645; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.communities
    ADD CONSTRAINT fk_rails_6beda9a645 FOREIGN KEY (schema_version_id) REFERENCES public.schema_versions(id) ON DELETE RESTRICT;


--
-- Name: entity_links fk_rails_6c08f572dd; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entity_links
    ADD CONSTRAINT fk_rails_6c08f572dd FOREIGN KEY (source_item_id) REFERENCES public.items(id) ON DELETE CASCADE;


--
-- Name: item_contributions fk_rails_73af22b63e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.item_contributions
    ADD CONSTRAINT fk_rails_73af22b63e FOREIGN KEY (contributor_id) REFERENCES public.contributors(id);


--
-- Name: assets fk_rails_747cd7500c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assets
    ADD CONSTRAINT fk_rails_747cd7500c FOREIGN KEY (community_id) REFERENCES public.communities(id) ON DELETE RESTRICT;


--
-- Name: granted_permissions fk_rails_79f89b52dc; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.granted_permissions
    ADD CONSTRAINT fk_rails_79f89b52dc FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE CASCADE;


--
-- Name: schema_versions fk_rails_7e7ef613db; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_versions
    ADD CONSTRAINT fk_rails_7e7ef613db FOREIGN KEY (schema_definition_id) REFERENCES public.schema_definitions(id) ON DELETE CASCADE;


--
-- Name: collections fk_rails_7f2fd62be2; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.collections
    ADD CONSTRAINT fk_rails_7f2fd62be2 FOREIGN KEY (schema_version_id) REFERENCES public.schema_versions(id) ON DELETE RESTRICT;


--
-- Name: collection_linked_items fk_rails_7fdede96da; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.collection_linked_items
    ADD CONSTRAINT fk_rails_7fdede96da FOREIGN KEY (target_id) REFERENCES public.items(id) ON DELETE RESTRICT;


--
-- Name: entity_links fk_rails_8181666751; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entity_links
    ADD CONSTRAINT fk_rails_8181666751 FOREIGN KEY (target_item_id) REFERENCES public.items(id) ON DELETE CASCADE;


--
-- Name: item_links fk_rails_818ba287b7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.item_links
    ADD CONSTRAINT fk_rails_818ba287b7 FOREIGN KEY (source_id) REFERENCES public.items(id) ON DELETE RESTRICT;


--
-- Name: entity_links fk_rails_81fdc77239; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entity_links
    ADD CONSTRAINT fk_rails_81fdc77239 FOREIGN KEY (source_collection_id) REFERENCES public.collections(id) ON DELETE CASCADE;


--
-- Name: communities fk_rails_840d8c73d5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.communities
    ADD CONSTRAINT fk_rails_840d8c73d5 FOREIGN KEY (schema_definition_id) REFERENCES public.schema_definitions(id) ON DELETE RESTRICT;


--
-- Name: community_memberships fk_rails_8bbf2ace3c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.community_memberships
    ADD CONSTRAINT fk_rails_8bbf2ace3c FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE RESTRICT;


--
-- Name: collection_contributions fk_rails_9955c93f4b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.collection_contributions
    ADD CONSTRAINT fk_rails_9955c93f4b FOREIGN KEY (collection_id) REFERENCES public.collections(id);


--
-- Name: collections fk_rails_a32ec34749; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.collections
    ADD CONSTRAINT fk_rails_a32ec34749 FOREIGN KEY (parent_id) REFERENCES public.collections(id) ON DELETE RESTRICT;


--
-- Name: items fk_rails_a5b4e81110; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.items
    ADD CONSTRAINT fk_rails_a5b4e81110 FOREIGN KEY (schema_version_id) REFERENCES public.schema_versions(id) ON DELETE RESTRICT;


--
-- Name: assets fk_rails_a8a9ebb434; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assets
    ADD CONSTRAINT fk_rails_a8a9ebb434 FOREIGN KEY (collection_id) REFERENCES public.collections(id) ON DELETE RESTRICT;


--
-- Name: user_group_memberships fk_rails_aece7151f8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_group_memberships
    ADD CONSTRAINT fk_rails_aece7151f8 FOREIGN KEY (user_group_id) REFERENCES public.user_groups(id) ON DELETE CASCADE;


--
-- Name: entity_links fk_rails_b6e9726cfa; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entity_links
    ADD CONSTRAINT fk_rails_b6e9726cfa FOREIGN KEY (target_community_id) REFERENCES public.communities(id) ON DELETE CASCADE;


--
-- Name: access_grants fk_rails_b889c8e828; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.access_grants
    ADD CONSTRAINT fk_rails_b889c8e828 FOREIGN KEY (user_group_id) REFERENCES public.user_groups(id) ON DELETE CASCADE;


--
-- Name: orderings fk_rails_c09738b6c8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orderings
    ADD CONSTRAINT fk_rails_c09738b6c8 FOREIGN KEY (schema_version_id) REFERENCES public.schema_versions(id) ON DELETE CASCADE;


--
-- Name: assets fk_rails_ce34fffb9d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assets
    ADD CONSTRAINT fk_rails_ce34fffb9d FOREIGN KEY (parent_id) REFERENCES public.assets(id) ON DELETE RESTRICT;


--
-- Name: granted_permissions fk_rails_d060f47715; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.granted_permissions
    ADD CONSTRAINT fk_rails_d060f47715 FOREIGN KEY (permission_id) REFERENCES public.permissions(id) ON DELETE CASCADE;


--
-- Name: access_grants fk_rails_d9b8218fcb; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.access_grants
    ADD CONSTRAINT fk_rails_d9b8218fcb FOREIGN KEY (collection_id) REFERENCES public.collections(id) ON DELETE CASCADE;


--
-- Name: granted_permissions fk_rails_de1e7295ac; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.granted_permissions
    ADD CONSTRAINT fk_rails_de1e7295ac FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: authorizing_entities fk_rails_e81ba90b04; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.authorizing_entities
    ADD CONSTRAINT fk_rails_e81ba90b04 FOREIGN KEY (entity_id) REFERENCES public.entities(id) ON DELETE CASCADE;


--
-- Name: entity_links fk_rails_eabc9b5139; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entity_links
    ADD CONSTRAINT fk_rails_eabc9b5139 FOREIGN KEY (target_collection_id) REFERENCES public.collections(id) ON DELETE CASCADE;


--
-- Name: item_contributions fk_rails_eca0986480; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.item_contributions
    ADD CONSTRAINT fk_rails_eca0986480 FOREIGN KEY (item_id) REFERENCES public.items(id);


--
-- Name: items fk_rails_ed5bf219ac; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.items
    ADD CONSTRAINT fk_rails_ed5bf219ac FOREIGN KEY (parent_id) REFERENCES public.items(id) ON DELETE RESTRICT;


--
-- Name: collection_contributions fk_rails_f2db32c240; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.collection_contributions
    ADD CONSTRAINT fk_rails_f2db32c240 FOREIGN KEY (contributor_id) REFERENCES public.contributors(id);


--
-- Name: entity_links fk_rails_f54d4f5cb3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entity_links
    ADD CONSTRAINT fk_rails_f54d4f5cb3 FOREIGN KEY (source_community_id) REFERENCES public.communities(id) ON DELETE CASCADE;


--
-- Name: orderings fk_rails_fb64dd7c38; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orderings
    ADD CONSTRAINT fk_rails_fb64dd7c38 FOREIGN KEY (community_id) REFERENCES public.communities(id) ON DELETE CASCADE;


--
-- Name: collections fk_rails_ff82e7b8d0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.collections
    ADD CONSTRAINT fk_rails_ff82e7b8d0 FOREIGN KEY (community_id) REFERENCES public.communities(id) ON DELETE RESTRICT;


--
-- Name: ordering_entries ordering_entries_ordering_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE public.ordering_entries
    ADD CONSTRAINT ordering_entries_ordering_id_fkey FOREIGN KEY (ordering_id) REFERENCES public.orderings(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20210428222857'),
('20210428222916'),
('20210504151248'),
('20210504152025'),
('20210513005944'),
('20210513010953'),
('20210513131104'),
('20210513131220'),
('20210513141534'),
('20210513141936'),
('20210513141949'),
('20210514160917'),
('20210514175612'),
('20210514175749'),
('20210514175833'),
('20210519201206'),
('20210519201212'),
('20210521132542'),
('20210525151755'),
('20210525151826'),
('20210525151834'),
('20210526172947'),
('20210526193105'),
('20210526195425'),
('20210526196331'),
('20210526205224'),
('20210526213652'),
('20210526250050'),
('20210527225127'),
('20210611162020'),
('20210611162848'),
('20210611162913'),
('20210611164648'),
('20210611164947'),
('20210611170719'),
('20210611170915'),
('20210611171346'),
('20210611171455'),
('20210611172811'),
('20210612183500'),
('20210612191855'),
('20210612202131'),
('20210622224648'),
('20210715163909'),
('20210719160950'),
('20210720164944'),
('20210720182059'),
('20210720182529'),
('20210720192446'),
('20210720192518'),
('20210723204008'),
('20210730165055'),
('20210730165659'),
('20210730170535'),
('20210730182534'),
('20210730183719'),
('20210730191337'),
('20210913191623'),
('20211005160744'),
('20211005183352'),
('20211013192548'),
('20211013193041'),
('20211013195329'),
('20211013235624');


