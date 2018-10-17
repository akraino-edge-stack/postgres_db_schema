/* 
 * Copyright (c) 2018 AT&T Intellectual Property. All rights reserved.
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *        http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */


drop sequence IF EXISTS akraino.seq_pod;
drop sequence IF EXISTS akraino.seq_rack;
drop sequence IF EXISTS akraino.seq_brack;
drop sequence IF EXISTS akraino.seq_node;
drop sequence IF EXISTS akraino.seq_software;
drop sequence IF EXISTS akraino.seq_hardware;
drop sequence IF EXISTS akraino.seq_onap;
drop sequence IF EXISTS akraino.seq_blueprint;
drop sequence IF EXISTS akraino.seq_edgeNode;
drop sequence IF EXISTS akraino.seq_yamltemplate;

drop table IF EXISTS akraino.onap;
drop table IF EXISTS akraino.usersession;
drop table IF EXISTS akraino.edgenode_software;
drop table IF EXISTS akraino.edgenode;
drop table IF EXISTS akraino.blueprint_rack;
drop table IF EXISTS akraino.blueprint;
drop table IF EXISTS akraino.genericrack;
drop table IF EXISTS akraino.software;
drop table IF EXISTS akraino.hardware;
drop table IF EXISTS akraino.pod;
drop table IF EXISTS akraino.edge_site_template_file;
drop table IF EXISTS akraino.edge_site;
drop table IF EXISTS akraino.region;
 
CREATE SCHEMA IF NOT EXISTS akraino
 AUTHORIZATION postgres;
 
CREATE TABLE akraino.pod
(
   pod_id bigint not NULL, 
   pod_name text not NULL unique,
   CONSTRAINT pod_id_pk PRIMARY KEY (pod_id)
) 
WITH (
  OIDS = FALSE
)
;
ALTER TABLE akraino.pod
  OWNER TO postgres; 

CREATE TABLE akraino.hardware
(
   hardware_id bigint not NULL, 
   hardware_name text not NULL,
   hardware_type text not null,
   CONSTRAINT hardware_id_pk PRIMARY KEY (hardware_id)
) 
WITH (
  OIDS = FALSE
)
;
ALTER TABLE akraino.hardware
  OWNER TO postgres;    

CREATE TABLE akraino.software
(
   software_id bigint not NULL, 
   software_name text not NULL,
   software_version text not null,
   CONSTRAINT software_id_pk PRIMARY KEY (software_id)
) 
WITH (
  OIDS = FALSE
)
;
ALTER TABLE akraino.software
  OWNER TO postgres;    
  
  
CREATE TABLE akraino.genericrack
(
   grack_id bigint not NULL, 
   rack_name text not NULL,
   rack_personality text not NULL,
   pod_id bigint null,
   CONSTRAINT grack_id_pk PRIMARY KEY (grack_id),
    CONSTRAINT pod_id_fk FOREIGN KEY (pod_id)
      REFERENCES akraino.pod (pod_id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
) 
WITH (
  OIDS = FALSE
)
;
ALTER TABLE akraino.genericrack
  OWNER TO postgres; 
  

CREATE TABLE akraino.blueprint
(
   blueprint_id bigint not NULL, 
   blueprint_name text not NULL,
   CONSTRAINT blueprint_id_pk PRIMARY KEY (blueprint_id)
) 
WITH (
  OIDS = FALSE
)
;
ALTER TABLE akraino.blueprint
  OWNER TO postgres;   

CREATE TABLE akraino.blueprint_rack
(
   brack_id bigint not NULL, 
   blueprint_id bigint null,
   grack_id bigint null,
   CONSTRAINT brack_id_pk PRIMARY KEY (brack_id),
   CONSTRAINT blueprint_id_fk FOREIGN KEY (blueprint_id)
      REFERENCES akraino.blueprint (blueprint_id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
   CONSTRAINT grack_id_fk FOREIGN KEY (grack_id)
      REFERENCES akraino.genericrack (grack_id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
) 
WITH (
  OIDS = FALSE
)
;
ALTER TABLE akraino.blueprint_rack
  OWNER TO postgres;   

CREATE TABLE akraino.edgenode
(
   edgenode_id bigint not NULL, 
   edgenode_name text not NULL,
   brack_id bigint null,
   hardware_id bigint null,
   CONSTRAINT edgenode_id_pk PRIMARY KEY (edgenode_id),
   CONSTRAINT brack_id_fk FOREIGN KEY (brack_id)
      REFERENCES akraino.blueprint_rack (brack_id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT hardware_id_fk FOREIGN KEY (hardware_id)
      REFERENCES akraino.hardware (hardware_id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION  
) 
WITH (
  OIDS = FALSE
)
;
ALTER TABLE akraino.edgenode
  OWNER TO postgres;   


CREATE TABLE akraino.edgenode_software
(
   edgenode_id bigint not NULL, 
   software_id bigint not NULL,

   CONSTRAINT edgenode_id_fk FOREIGN KEY (edgenode_id)
      REFERENCES akraino.edgenode (edgenode_id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT software_id_fk FOREIGN KEY (software_id)
      REFERENCES akraino.software (software_id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION  
) 
WITH (
  OIDS = FALSE
)
;
ALTER TABLE akraino.edgenode_software
  OWNER TO postgres;  
  
  
CREATE TABLE akraino.usersession
(
   login_id text not NULL, 
   token_id text not NULL, 
   crt_dt timestamptz not NULL, 
   CONSTRAINT login_id_pk PRIMARY KEY (login_id)
) 
WITH (
  OIDS = FALSE
)
;
ALTER TABLE akraino.usersession
  OWNER TO postgres;
  

CREATE TABLE akraino.region
(
   region_id bigint not NULL, 
   region_name text not NULL, 
   crt_dt timestamptz not NULL, 
   crt_login_id text not NULL, 
   upd_dt timestamptz not NULL, 
   upd_login_id text not null, 
   CONSTRAINT pk_region_id_pk PRIMARY KEY (region_id)
) 
WITH (
  OIDS = FALSE
)
;
ALTER TABLE akraino.region
  OWNER TO postgres;


CREATE TABLE akraino.edge_site
(
   edge_site_id bigint NOT NULL, 
   edge_site_name text NOT NULL, 
   edge_site_ip text NULL, 
   edge_site_user text NULL, 
   edge_site_pwd text NULL, 
   edge_site_blueprint text NULL,
   input_file bytea NULL, 
   output_yaml_file_1 bytea NULL,
   output_yaml_file_2 bytea NULL,
   output_yaml_file_3 bytea NULL,
   output_yaml_file_4 bytea NULL,
   output_yaml_file_5 bytea NULL,
   output_yaml_file_6 bytea NULL,
   output_yaml_file_7 bytea NULL,
   output_yaml_file_8 bytea NULL,
   output_yaml_file_9 bytea NULL,
   output_yaml_file_10 bytea NULL,
   output_yaml_file_11 bytea NULL,
   output_yaml_file_12 bytea NULL,
   output_yaml_file_13 bytea NULL,
   output_yaml_file_14 bytea NULL,
   output_yaml_file_15 bytea NULL,
   output_yaml_file_16 bytea NULL,
   output_yaml_file_17 bytea NULL,
   output_yaml_file_18 bytea NULL,
   output_yaml_file_19 bytea NULL,
   output_yaml_file_20 bytea NULL,
   output_yaml_file_21 bytea NULL,
   output_yaml_file_22 bytea NULL,
   output_yaml_file_23 bytea NULL,
   output_yaml_file_24 bytea NULL,
   build_status text NULL, 
   build_dt timestamptz NULL,
   multinode_createtar_status text NULL,    
   multinode_genesisnode_status text NULL,    
   multinode_deploytool_status text NULL,  
   multinode_transferfile_status text NULL, 
   deploy_status text NULL,  
   onap_status text NULL,
   tempest_status text NULL,
   vcdn_status text NULL,
   deploy_dt timestamptz NULL,
   crt_dt timestamptz NOT NULL, 
   crt_login_id text NOT NULL, 
   upd_dt timestamptz NOT NULL, 
   upd_login_id text NOT NULL, 
   region_id bigint NOT NULL,
   CONSTRAINT edge_site_id_pk PRIMARY KEY (edge_site_id),
   CONSTRAINT region_id_fk FOREIGN KEY (region_id)
      REFERENCES akraino.region (region_id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION

) 
WITH (
  OIDS = FALSE
)
;
ALTER TABLE akraino.edge_site
  OWNER TO postgres;
  

CREATE TABLE akraino.edge_site_template_file
(   
   yamltemplate_id bigint NOT NULL,
   template_file_name text NOT NULL,
   template_file_location text NOT NULL,
   template_file_content bytea NOT NULL,
   crt_dt timestamptz NULL, 
   crt_login_id text NULL, 
   upd_dt timestamptz NULL, 
   upd_login_id text NULL,
   CONSTRAINT edge_site_yaml_id_pk PRIMARY KEY (yamltemplate_id)   
)
WITH (
  OIDS = FALSE
)
;
ALTER TABLE akraino.edge_site_template_file
  OWNER TO postgres;
;

CREATE TABLE akraino.onap
(
   onap_id bigint not NULL, 
   edge_site_id bigint NOT NULL, 
   input_file bytea NULL,
   public_net_name text NULL, 
   public_subnet_cidr text NULL, 
   public_subnet_allocation_start text NULL, 
   public_subnet_allocation_end text null, 
   public_subnet_dns_nameserver text NULL, 
   public_subnet_gateway_ip text NULL, 
   onap_vm_public_key text NULL, 
   onap_repo text null, 
   http_proxy text NULL, 
   https_proxy text NULL, 
   no_proxy text null,
   CONSTRAINT onap_id_pk PRIMARY KEY (onap_id),
   CONSTRAINT edge_site_id_fk FOREIGN KEY (edge_site_id)
      REFERENCES akraino.edge_site (edge_site_id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
) 
WITH (
  OIDS = FALSE
)
;
ALTER TABLE akraino.onap
  OWNER TO postgres;
  
CREATE SEQUENCE akraino.seq_pod
  START WITH 1 INCREMENT BY 1;

CREATE SEQUENCE akraino.seq_rack
  START WITH 1 INCREMENT BY 1;

CREATE SEQUENCE akraino.seq_brack
  START WITH 1 INCREMENT BY 1;

CREATE SEQUENCE akraino.seq_node
  START WITH 1 INCREMENT BY 1;
  
CREATE SEQUENCE akraino.seq_software
  START WITH 1 INCREMENT BY 1;  

CREATE SEQUENCE akraino.seq_hardware
  START WITH 1 INCREMENT BY 1;  
  
CREATE SEQUENCE akraino.seq_onap
  START WITH 1 INCREMENT BY 1;

CREATE SEQUENCE akraino.seq_blueprint  
  START WITH 1 INCREMENT BY 1;
  
CREATE SEQUENCE akraino.seq_edgeNode
  START WITH 1 INCREMENT BY 1;

CREATE SEQUENCE akraino.seq_yamltemplate
  START WITH 1 INCREMENT BY 1;  
  
  
insert into akraino.region values(1, 'US Northeast', now(), user, now(), user);

insert into akraino.edge_site( edge_site_id, edge_site_name, crt_login_id, crt_dt, upd_login_id, upd_dt, region_id) values(1, 'MTN1', user,  now(), user, now(),1);
insert into akraino.edge_site( edge_site_id, edge_site_name,  crt_login_id, crt_dt, upd_login_id, upd_dt, region_id) values(2, 'MTN2', user,  now(), user, now(),1);

commit;

