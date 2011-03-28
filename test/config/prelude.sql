

CREATE TABLE "Prelude_Action" (
  "_message_ident" bigint(20)  NOT NULL,
  "_index" tinyint(4) NOT NULL,
  "description" varchar(255) DEFAULT NULL,
  "category" varchar(255) NOT NULL,
  PRIMARY KEY ("_message_ident","_index")
);



CREATE TABLE "Prelude_AdditionalData" (
  "_message_ident" bigint(20)  NOT NULL,
  "_parent_type" varchar(255) NOT NULL,
  "_index" tinyint(4) NOT NULL,
  "type" varchar(255) NOT NULL,
  "meaning" varchar(255) DEFAULT NULL,
  "data" blob NOT NULL,
  PRIMARY KEY ("_parent_type","_message_ident","_index")
);



CREATE TABLE "Prelude_Address" (
  "_message_ident" bigint(20)  NOT NULL,
  "_parent_type" varchar(255) NOT NULL,
  "_parent0_index" smallint(6) NOT NULL,
  "_index" tinyint(4) NOT NULL,
  "ident" varchar(255) DEFAULT NULL,
  "category" varchar(255) NOT NULL,
  "vlan_name" varchar(255) DEFAULT NULL,
  "vlan_num" int(10)  DEFAULT NULL,
  "address" varchar(255) NOT NULL,
  "netmask" varchar(255) DEFAULT NULL,
  PRIMARY KEY ("_parent_type","_message_ident","_parent0_index","_index")
);



CREATE TABLE "Prelude_Alert" (
  "_ident" bigint(20)  NOT NULL,
  "messageid" varchar(255) DEFAULT NULL,
  PRIMARY KEY ("_ident")
);



CREATE TABLE "Prelude_Alertident" (
  "_message_ident" bigint(20)  NOT NULL,
  "_index" int(11) NOT NULL,
  "_parent_type" varchar(255) NOT NULL,
  "alertident" varchar(255) NOT NULL,
  "analyzerid" varchar(255) DEFAULT NULL,
  PRIMARY KEY ("_parent_type","_message_ident","_index")
);



CREATE TABLE "Prelude_Analyzer" (
  "_message_ident" bigint(20)  NOT NULL,
  "_parent_type" varchar(255) DEFAULT NULL,
  "_index" tinyint(4) DEFAULT NULL,
  "analyzerid" varchar(255) DEFAULT NULL,
  "name" varchar(255) DEFAULT NULL,
  "manufacturer" varchar(255) DEFAULT NULL,
  "model" varchar(255) DEFAULT NULL,
  "version" varchar(255) DEFAULT NULL,
  "class" varchar(255) DEFAULT NULL,
  "ostype" varchar(255) DEFAULT NULL,
  "osversion" varchar(255) DEFAULT NULL,
  PRIMARY KEY ("_parent_type","_message_ident","_index")
);



CREATE TABLE "Prelude_AnalyzerTime" (
  "_message_ident" bigint(20)  NOT NULL,
  "_parent_type" varchar(255) NOT NULL,
  "time" datetime NOT NULL,
  "usec" int(10)  NOT NULL,
  "gmtoff" int(11) NOT NULL,
  PRIMARY KEY ("_parent_type","_message_ident")
);



CREATE TABLE "Prelude_Assessment" (
  "_message_ident" bigint(20)  NOT NULL,
  PRIMARY KEY ("_message_ident")
);



CREATE TABLE "Prelude_Checksum" (
  "_message_ident" bigint(20)  NOT NULL,
  "_parent0_index" smallint(6) NOT NULL,
  "_parent1_index" tinyint(4) NOT NULL,
  "_index" tinyint(4) NOT NULL,
  "algorithm" varchar(255) NOT NULL,
  "value" varchar(255) NOT NULL,
  "checksum_key" varchar(255) DEFAULT NULL,
  PRIMARY KEY ("_message_ident","_parent0_index","_parent1_index","_index")
);



CREATE TABLE "Prelude_Classification" (
  "_message_ident" bigint(20)  NOT NULL,
  "ident" varchar(255) DEFAULT NULL,
  "text" varchar(255) NOT NULL,
  PRIMARY KEY ("_message_ident")
);



CREATE TABLE "Prelude_Confidence" (
  "_message_ident" bigint(20)  NOT NULL,
  "confidence" float DEFAULT NULL,
  "rating" varchar(255) NOT NULL,
  PRIMARY KEY ("_message_ident")
);



CREATE TABLE "Prelude_CorrelationAlert" (
  "_message_ident" bigint(20)  NOT NULL,
  "name" varchar(255) NOT NULL,
  PRIMARY KEY ("_message_ident")
);



CREATE TABLE "Prelude_CreateTime" (
  "_message_ident" bigint(20)  NOT NULL,
  "_parent_type" varchar(255) NOT NULL,
  "time" datetime NOT NULL,
  "usec" int(10)  NOT NULL,
  "gmtoff" int(11) NOT NULL,
  PRIMARY KEY ("_parent_type","_message_ident")
);



CREATE TABLE "Prelude_DetectTime" (
  "_message_ident" bigint(20)  NOT NULL,
  "time" datetime NOT NULL,
  "usec" int(10)  DEFAULT NULL,
  "gmtoff" int(11) DEFAULT NULL,
  PRIMARY KEY ("_message_ident")
);



CREATE TABLE "Prelude_File" (
  "_message_ident" bigint(20)  NOT NULL,
  "_parent0_index" smallint(6) NOT NULL,
  "_index" tinyint(4) NOT NULL,
  "ident" varchar(255) DEFAULT NULL,
  "path" varchar(255) NOT NULL,
  "name" varchar(255) NOT NULL,
  "category" varchar(255) DEFAULT NULL,
  "create_time" datetime DEFAULT NULL,
  "create_time_gmtoff" int(11) DEFAULT NULL,
  "modify_time" datetime DEFAULT NULL,
  "modify_time_gmtoff" int(11) DEFAULT NULL,
  "access_time" datetime DEFAULT NULL,
  "access_time_gmtoff" int(11) DEFAULT NULL,
  "data_size" int(10)  DEFAULT NULL,
  "disk_size" int(10)  DEFAULT NULL,
  "fstype" varchar(255) DEFAULT NULL,
  "file_type" varchar(255) DEFAULT NULL,
  PRIMARY KEY ("_message_ident","_parent0_index","_index")
);



CREATE TABLE "Prelude_FileAccess" (
  "_message_ident" bigint(20)  NOT NULL,
  "_parent0_index" smallint(6) NOT NULL,
  "_parent1_index" tinyint(4) NOT NULL,
  "_index" tinyint(4) NOT NULL,
  PRIMARY KEY ("_message_ident","_parent0_index","_parent1_index","_index")
);



CREATE TABLE "Prelude_FileAccess_Permission" (
  "_message_ident" bigint(20)  NOT NULL,
  "_parent0_index" smallint(6) NOT NULL,
  "_parent1_index" tinyint(4) NOT NULL,
  "_parent2_index" tinyint(4) NOT NULL,
  "_index" tinyint(4) NOT NULL,
  "permission" varchar(255) NOT NULL,
  PRIMARY KEY ("_message_ident","_parent0_index","_parent1_index","_parent2_index","_index")
);



CREATE TABLE "Prelude_Heartbeat" (
  "_ident" bigint(20)  NOT NULL,
  "messageid" varchar(255) DEFAULT NULL,
  "heartbeat_interval" int(11) DEFAULT NULL,
  PRIMARY KEY ("_ident")
);



CREATE TABLE "Prelude_Impact" (
  "_message_ident" bigint(20)  NOT NULL,
  "description" text,
  "severity" varchar(255) DEFAULT NULL,
  "completion" varchar(255) DEFAULT NULL,
  "type" varchar(255) DEFAULT NULL,
  PRIMARY KEY ("_message_ident")
);



CREATE TABLE "Prelude_Inode" (
  "_message_ident" bigint(20)  NOT NULL,
  "_parent0_index" smallint(6) NOT NULL,
  "_parent1_index" tinyint(4) NOT NULL,
  "change_time" datetime DEFAULT NULL,
  "change_time_gmtoff" int(11) DEFAULT NULL,
  "number" int(10)  DEFAULT NULL,
  "major_device" int(10)  DEFAULT NULL,
  "minor_device" int(10)  DEFAULT NULL,
  "c_major_device" int(10)  DEFAULT NULL,
  "c_minor_device" int(10)  DEFAULT NULL,
  PRIMARY KEY ("_message_ident","_parent0_index","_parent1_index")
);



CREATE TABLE "Prelude_Linkage" (
  "_message_ident" bigint(20)  NOT NULL,
  "_parent0_index" smallint(6) NOT NULL,
  "_parent1_index" tinyint(4) NOT NULL,
  "_index" tinyint(4) NOT NULL,
  "category" varchar(255) NOT NULL,
  "name" varchar(255) NOT NULL,
  "path" varchar(255) NOT NULL,
  PRIMARY KEY ("_message_ident","_parent0_index","_parent1_index","_index")
);



CREATE TABLE "Prelude_Node" (
  "_message_ident" bigint(20)  NOT NULL,
  "_parent_type" varchar(255) NOT NULL,
  "_parent0_index" smallint(6) NOT NULL,
  "ident" varchar(255) DEFAULT NULL,
  "category" varchar(255) DEFAULT NULL,
  "location" varchar(255) DEFAULT NULL,
  "name" varchar(255) DEFAULT NULL,
  PRIMARY KEY ("_parent_type","_message_ident","_parent0_index")
);



CREATE TABLE "Prelude_OverflowAlert" (
  "_message_ident" bigint(20)  NOT NULL,
  "program" varchar(255) NOT NULL,
  "size" int(10)  DEFAULT NULL,
  "buffer" blob,
  PRIMARY KEY ("_message_ident")
);



CREATE TABLE "Prelude_Process" (
  "_message_ident" bigint(20)  NOT NULL,
  "_parent_type" varchar(255) NOT NULL,
  "_parent0_index" smallint(6) NOT NULL,
  "ident" varchar(255) DEFAULT NULL,
  "name" varchar(255) NOT NULL,
  "pid" int(10)  DEFAULT NULL,
  "path" varchar(255) DEFAULT NULL,
  PRIMARY KEY ("_parent_type","_message_ident","_parent0_index")
);



CREATE TABLE "Prelude_ProcessArg" (
  "_message_ident" bigint(20)  NOT NULL,
  "_parent_type" varchar(255) NOT NULL DEFAULT 'A',
  "_parent0_index" smallint(6) NOT NULL,
  "_index" tinyint(4) NOT NULL,
  "arg" varchar(255) NOT NULL,
  PRIMARY KEY ("_parent_type","_message_ident","_parent0_index","_index")
);



CREATE TABLE "Prelude_ProcessEnv" (
  "_message_ident" bigint(20)  NOT NULL,
  "_parent_type" varchar(255) NOT NULL,
  "_parent0_index" smallint(6) NOT NULL,
  "_index" tinyint(4) NOT NULL,
  "env" varchar(255) NOT NULL,
  PRIMARY KEY ("_parent_type","_message_ident","_parent0_index","_index")
);



CREATE TABLE "Prelude_Reference" (
  "_message_ident" bigint(20)  NOT NULL,
  "_index" tinyint(4) NOT NULL,
  "origin" varchar(255) NOT NULL,
  "name" varchar(255) NOT NULL,
  "url" varchar(255) NOT NULL,
  "meaning" varchar(255) DEFAULT NULL,
  PRIMARY KEY ("_message_ident","_index")
);



CREATE TABLE "Prelude_Service" (
  "_message_ident" bigint(20)  NOT NULL,
  "_parent_type" varchar(255) DEFAULT NULL,
  "_parent0_index" smallint(6) DEFAULT NULL,
  "ident" varchar(255) DEFAULT NULL,
  "ip_version" tinyint(3)  DEFAULT NULL,
  "name" varchar(255) DEFAULT NULL,
  "port" smallint(5)  DEFAULT NULL,
  "iana_protocol_number" tinyint(3)  DEFAULT NULL,
  "iana_protocol_name" varchar(255) DEFAULT NULL,
  "portlist" varchar(255) DEFAULT NULL,
  "protocol" varchar(255) DEFAULT NULL,
  PRIMARY KEY ("_parent_type","_message_ident","_parent0_index")
);



CREATE TABLE "Prelude_SnmpService" (
  "_message_ident" bigint(20)  NOT NULL,
  "_parent_type" varchar(255) NOT NULL,
  "_parent0_index" smallint(6) NOT NULL,
  "snmp_oid" varchar(255) DEFAULT NULL,
  "message_processing_model" int(10)  DEFAULT NULL,
  "security_model" int(10)  DEFAULT NULL,
  "security_name" varchar(255) DEFAULT NULL,
  "security_level" int(10)  DEFAULT NULL,
  "context_name" varchar(255) DEFAULT NULL,
  "context_engine_id" varchar(255) DEFAULT NULL,
  "command" varchar(255) DEFAULT NULL,
  PRIMARY KEY ("_parent_type","_message_ident","_parent0_index")
);



CREATE TABLE "Prelude_Source" (
  "_message_ident" bigint(20)  NOT NULL,
  "_index" smallint(6) NOT NULL,
  "ident" varchar(255) DEFAULT NULL,
  "spoofed" varchar(255) NOT NULL,
  "interface" varchar(255) DEFAULT NULL,
  PRIMARY KEY ("_message_ident","_index")
);



CREATE TABLE "Prelude_Target" (
  "_message_ident" bigint(20)  NOT NULL,
  "_index" smallint(6) NOT NULL,
  "ident" varchar(255) DEFAULT NULL,
  "decoy" varchar(255) NOT NULL,
  "interface" varchar(255) DEFAULT NULL,
  PRIMARY KEY ("_message_ident","_index")
);



CREATE TABLE "Prelude_ToolAlert" (
  "_message_ident" bigint(20)  NOT NULL,
  "name" varchar(255) NOT NULL,
  "command" varchar(255) DEFAULT NULL,
  PRIMARY KEY ("_message_ident")
);



CREATE TABLE "Prelude_User" (
  "_message_ident" bigint(20)  NOT NULL,
  "_parent_type" varchar(255) NOT NULL,
  "_parent0_index" smallint(6) NOT NULL,
  "ident" varchar(255) DEFAULT NULL,
  "category" varchar(255) NOT NULL,
  PRIMARY KEY ("_parent_type","_message_ident","_parent0_index")
);



CREATE TABLE "Prelude_UserId" (
  "_message_ident" bigint(20)  NOT NULL,
  "_parent_type" varchar(255) NOT NULL,
  "_parent0_index" smallint(6) NOT NULL,
  "_parent1_index" tinyint(4) NOT NULL,
  "_parent2_index" tinyint(4) NOT NULL,
  "_index" tinyint(4) NOT NULL,
  "ident" varchar(255) DEFAULT NULL,
  "type" varchar(255) NOT NULL,
  "name" varchar(255) DEFAULT NULL,
  "tty" varchar(255) DEFAULT NULL,
  "number" int(10)  DEFAULT NULL,
  PRIMARY KEY ("_parent_type","_message_ident","_parent0_index","_parent1_index","_parent2_index","_index")
);



CREATE TABLE "Prelude_WebService" (
  "_message_ident" bigint(20)  NOT NULL,
  "_parent_type" varchar(255) NOT NULL,
  "_parent0_index" smallint(6) NOT NULL,
  "url" varchar(255) NOT NULL,
  "cgi" varchar(255) DEFAULT NULL,
  "http_method" varchar(255) DEFAULT NULL,
  PRIMARY KEY ("_parent_type","_message_ident","_parent0_index")
);



CREATE TABLE "Prelude_WebServiceArg" (
  "_message_ident" bigint(20)  NOT NULL,
  "_parent_type" varchar(255) NOT NULL,
  "_parent0_index" smallint(6) NOT NULL,
  "_index" tinyint(4) NOT NULL,
  "arg" varchar(255) NOT NULL,
  PRIMARY KEY ("_parent_type","_message_ident","_parent0_index","_index")
);



CREATE TABLE "_format" (
  "name" varchar(255) NOT NULL,
  "version" varchar(255) NOT NULL
);

