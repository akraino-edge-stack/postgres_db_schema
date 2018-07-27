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


CREATE SCHEMA akraino
  AUTHORIZATION postgres;


CREATE TABLE akraino.pod
(
   pod_id bigint not NULL, 
   pod_name text not NULL,
   CONSTRAINT pod_id_pk PRIMARY KEY (pod_id)
) 
WITH (
  OIDS = FALSE
)
;
ALTER TABLE akraino.pod
  OWNER TO postgres; 

CREATE TABLE akraino.rack
(
   rack_id bigint not NULL, 
   rack_name text not NULL,
   rack_personality text not NULL,
   pod_id bigint not null,
   CONSTRAINT rack_id_pk PRIMARY KEY (rack_id),
    CONSTRAINT pod_id_fk FOREIGN KEY (pod_id)
      REFERENCES akraino.pod (pod_id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
) 
WITH (
  OIDS = FALSE
)
;
ALTER TABLE akraino.rack
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
   input_file bytea NOT NULL, 
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
   build_status text NULL, 
   build_dt timestamptz NULL,
   deploy_createtar_status text NULL,    
   deploy_genesisnodestatus_status text NULL,    
   deploy_deploytoolstatus_status text NULL,    
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
  
 
CREATE TABLE akraino.edge_site_input_yaml_files
(   
   id bigint NOT NULL,
   input_yaml_file_name text NOT NULL,
   input_yaml_file_location text NOT NULL,
   input_yaml_file_content bytea NOT NULL,
   crt_dt timestamptz NOT NULL, 
   crt_login_id text NOT NULL, 
   upd_dt timestamptz NOT NULL, 
   upd_login_id text NOT NULL,
	CONSTRAINT edge_site_yaml_id_pk PRIMARY KEY (id)   
)
WITH (
  OIDS = FALSE
)
;
ALTER TABLE akraino.edge_site_input_yaml_files
  OWNER TO postgres;
;

CREATE TABLE akraino.onap
(
   onap_id bigint not NULL, 
   edge_site_name text NOT NULL, 
   public_net_name text not NULL, 
   public_subnet_cidr text not NULL, 
   public_subnet_allocation_start text not NULL, 
   public_subnet_allocation_end text not null, 
   public_subnet_dns_nameserver text not NULL, 
   public_subnet_gateway_ip text not NULL, 
   onap_vm_public_key text not NULL, 
   onap_repo text not null, 
   http_proxy text not NULL, 
   https_proxy text not NULL, 
   no_proxy text not null,
   CONSTRAINT onap_id_pk PRIMARY KEY (onap_id)
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

insert into akraino.region values(1, 'US Northeast', now(), user, now(), user);

insert into akraino.edge_site( edge_site_id, edge_site_name, crt_login_id, crt_dt, upd_login_id, upd_dt, region_id) values(1, 'MTN1', user,  now(), user, now(),1);
insert into akraino.edge_site( edge_site_id, edge_site_name,  crt_login_id, crt_dt, upd_login_id, upd_dt, region_id) values(2, 'MTN2', user,  now(), user, now(),1);


insert into akraino.edge_site_input_yaml_files values (1, 'mycontrolplane_hp', '/profiles/host/',bytea(pg_read_file('profiles/host/mycontrolplane_hp.j2')), now(), user, now(), user);
insert into akraino.edge_site_input_yaml_files values (2, 'generic', '/profiles/hardware/',bytea(pg_read_file('profiles/hardware/generic.j2')), now(), user, now(), user);
insert into akraino.edge_site_input_yaml_files values (3, 'region', '/profiles/',bytea(pg_read_file('profiles/region.j2')), now(), user, now(), user);
insert into akraino.edge_site_input_yaml_files values (4, 'bootaction', '/baremetal/',bytea(pg_read_file('baremetal/bootaction.j2')), now(), user, now(), user);
insert into akraino.edge_site_input_yaml_files values (5, 'localadmin_ssh_public_key', '/secrets/publickey/',bytea(pg_read_file('secrets/publickey/localadmin_ssh_public_key.j2')), now(), user, now(), user);
insert into akraino.edge_site_input_yaml_files values (6, 'ipmi_admin_password', '/secrets/passphrases/',bytea(pg_read_file('secrets/passphrases/ipmi_admin_password.j2')), now(), user, now(), user);
insert into akraino.edge_site_input_yaml_files values (7, 'ceph-update', '/software/charts/ucp/ceph/',bytea(pg_read_file('software/charts/ucp/ceph/ceph-update.j2')), now(), user, now(), user);
insert into akraino.edge_site_input_yaml_files values (8, 'ingress', '/software/charts/kubernetes/ingress/',bytea(pg_read_file('software/charts/kubernetes/ingress/ingress.j2')), now(), user, now(), user);
insert into akraino.edge_site_input_yaml_files values (9, 'calico', '/software/charts/kubernetes/container-networking/',bytea(pg_read_file('software/charts/kubernetes/container-networking/calico.j2')), now(), user, now(), user);
insert into akraino.edge_site_input_yaml_files values (10, 'neutron', '/software/charts/osh/openstack-compute-kit/',bytea(pg_read_file('software/charts/osh/openstack-compute-kit/neutron.j2')), now(), user, now(), user);
insert into akraino.edge_site_input_yaml_files values (11, 'ipmi_admin_password', '/aic-clcp-security-manifests/secrets/passphrases/',bytea(pg_read_file('aic-clcp-security-manifests/secrets/passphrases/ipmi_admin_password.j2')), now(), user, now(), user);
insert into akraino.edge_site_input_yaml_files values (12, 'site-definition', '/aic-clcp-security-manifests/',bytea(pg_read_file('aic-clcp-security-manifests/site-definition.j2')), now(), user, now(), user);
insert into akraino.edge_site_input_yaml_files values (13, 'common-addresses', '/networks/',bytea(pg_read_file('networks/common-addresses.j2')), now(), user, now(), user);
insert into akraino.edge_site_input_yaml_files values (14, 'pki-catalog', '/pki/',bytea(pg_read_file('pki/pki-catalog.j2')), now(), user, now(), user);
insert into akraino.edge_site_input_yaml_files values (15, 'ceph', '/software/charts/ucp/ceph/',bytea(pg_read_file('software/charts/ucp/ceph/ceph.j2')), now(), user, now(), user);
insert into akraino.edge_site_input_yaml_files values (16, 'nova', '/software/charts/osh/openstack-compute-kit/',bytea(pg_read_file('software/charts/osh/openstack-compute-kit/nova.j2')), now(), user, now(), user);
insert into akraino.edge_site_input_yaml_files values (17, 'promenade', '/software/charts/ucp/ceph/promenade/',bytea(pg_read_file('software/charts/ucp/ceph/promenade/promenade.j2')), now(), user, now(), user);
insert into akraino.edge_site_input_yaml_files values (18, 'etcd', '/software/charts/kubernetes/etcd/',bytea(pg_read_file('software/charts/kubernetes/etcd/etcd.j2')), now(), user, now(), user);
insert into akraino.edge_site_input_yaml_files values (19, 'rack', '/baremetal/',bytea(pg_read_file('baremetal/rack.j2')), now(), user, now(), user);
insert into akraino.edge_site_input_yaml_files values (20, 'etcd', '/software/charts/kubernetes/container-networking/',bytea(pg_read_file('software/charts/kubernetes/container-networking/etcd.j2')), now(), user, now(), user);
insert into akraino.edge_site_input_yaml_files values (21, 'rack', '/networks/physical/',bytea(pg_read_file('networks/physical/rack.j2')), now(), user, now(), user);


commit;


