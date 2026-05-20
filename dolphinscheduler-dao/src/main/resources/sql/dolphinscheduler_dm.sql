-- ----------------------------
-- Quartz Tables
-- ----------------------------
drop table if exists QRTZ_FIRED_TRIGGERS;
drop table if exists QRTZ_PAUSED_TRIGGER_GRPS;
drop table if exists QRTZ_SCHEDULER_STATE;
drop table if exists QRTZ_LOCKS;
drop table if exists QRTZ_SIMPLE_TRIGGERS;
drop table if exists QRTZ_SIMPROP_TRIGGERS;
drop table if exists QRTZ_CRON_TRIGGERS;
drop table if exists QRTZ_BLOB_TRIGGERS;
drop table if exists QRTZ_TRIGGERS;
drop table if exists QRTZ_JOB_DETAILS;
drop table if exists QRTZ_CALENDARS;

create table qrtz_job_details
(
    sched_name        varchar(120) not null,
    job_name          varchar(200) not null,
    job_group         varchar(200) not null,
    description       varchar(250) null,
    job_class_name    varchar(250) not null,
    is_durable        varchar(1)   not null,
    is_nonconcurrent  varchar(1)   not null,
    is_update_data    varchar(1)   not null,
    requests_recovery varchar(1)   not null,
    job_data          blob null,
    primary key (sched_name, job_name, job_group)
);

create table qrtz_triggers
(
    sched_name     varchar(120) not null,
    trigger_name   varchar(200) not null,
    trigger_group  varchar(200) not null,
    job_name       varchar(200) not null,
    job_group      varchar(200) not null,
    description    varchar(250) null,
    next_fire_time bigint null,
    prev_fire_time bigint null,
    priority       integer null,
    trigger_state  varchar(16)  not null,
    trigger_type   varchar(8)   not null,
    start_time     bigint       not null,
    end_time       bigint null,
    calendar_name  varchar(200) null,
    misfire_instr  smallint null,
    job_data       blob null,
    primary key (sched_name, trigger_name, trigger_group)
);

create table qrtz_simple_triggers
(
    sched_name      varchar(120) not null,
    trigger_name    varchar(200) not null,
    trigger_group   varchar(200) not null,
    repeat_count    bigint       not null,
    repeat_interval bigint       not null,
    times_triggered bigint       not null,
    primary key (sched_name, trigger_name, trigger_group)
);

create table qrtz_cron_triggers
(
    sched_name      varchar(120) not null,
    trigger_name    varchar(200) not null,
    trigger_group   varchar(200) not null,
    cron_expression varchar(120) not null,
    time_zone_id    varchar(80),
    primary key (sched_name, trigger_name, trigger_group)
);

create table qrtz_simprop_triggers
(
    sched_name    varchar(120) not null,
    trigger_name  varchar(200) not null,
    trigger_group varchar(200) not null,
    str_prop_1    varchar(512) null,
    str_prop_2    varchar(512) null,
    str_prop_3    varchar(512) null,
    int_prop_1    int null,
    int_prop_2    int null,
    long_prop_1   bigint null,
    long_prop_2   bigint null,
    dec_prop_1    numeric(13, 4) null,
    dec_prop_2    numeric(13, 4) null,
    bool_prop_1   varchar(1) null,
    bool_prop_2   varchar(1) null,
    primary key (sched_name, trigger_name, trigger_group)
);

create table qrtz_blob_triggers
(
    sched_name    varchar(120) not null,
    trigger_name  varchar(200) not null,
    trigger_group varchar(200) not null,
    blob_data     blob null,
    primary key (sched_name, trigger_name, trigger_group)
);

create table qrtz_calendars
(
    sched_name    varchar(120) not null,
    calendar_name varchar(200) not null,
    calendar      blob         not null,
    primary key (sched_name, calendar_name)
);

create table qrtz_paused_trigger_grps
(
    sched_name    varchar(120) not null,
    trigger_group varchar(200) not null,
    primary key (sched_name, trigger_group)
);

create table qrtz_fired_triggers
(
    sched_name        varchar(120) not null,
    entry_id          varchar(200) not null,
    trigger_name      varchar(200) not null,
    trigger_group     varchar(200) not null,
    instance_name     varchar(200) not null,
    fired_time        bigint       not null,
    sched_time        bigint       not null,
    priority          integer      not null,
    state             varchar(16)  not null,
    job_name          varchar(200) null,
    job_group         varchar(200) null,
    is_nonconcurrent  varchar(1) null,
    requests_recovery varchar(1) null,
    primary key (sched_name, entry_id)
);

create table qrtz_scheduler_state
(
    sched_name        varchar(120) not null,
    instance_name     varchar(200) not null,
    last_checkin_time bigint       not null,
    checkin_interval  bigint       not null,
    primary key (sched_name, instance_name)
);

create table qrtz_locks
(
    sched_name varchar(120) not null,
    lock_name  varchar(40)  not null,
    primary key (sched_name, lock_name)
);

create index idx_qrtz_j_req_recovery on qrtz_job_details (sched_name, requests_recovery);
create index idx_qrtz_j_grp on qrtz_job_details (sched_name, job_group);

create index idx_qrtz_t_j on qrtz_triggers (sched_name, job_name, job_group);
create index idx_qrtz_t_jg on qrtz_triggers (sched_name, job_group);
create index idx_qrtz_t_c on qrtz_triggers (sched_name, calendar_name);
create index idx_qrtz_t_g on qrtz_triggers (sched_name, trigger_group);
create index idx_qrtz_t_state on qrtz_triggers (sched_name, trigger_state);
create index idx_qrtz_t_n_state on qrtz_triggers (sched_name, trigger_name, trigger_group, trigger_state);
create index idx_qrtz_t_n_g_state on qrtz_triggers (sched_name, trigger_group, trigger_state);
create index idx_qrtz_t_next_fire_time on qrtz_triggers (sched_name, next_fire_time);
create index idx_qrtz_t_nft_st on qrtz_triggers (sched_name, trigger_state, next_fire_time);
create index idx_qrtz_t_nft_misfire on qrtz_triggers (sched_name, misfire_instr, next_fire_time);
create index idx_qrtz_t_nft_st_misfire on qrtz_triggers (sched_name, misfire_instr, next_fire_time, trigger_state);
create index idx_qrtz_t_nft_st_misfire_grp on qrtz_triggers (sched_name, misfire_instr, next_fire_time, trigger_group,
                                                             trigger_state);

create index idx_qrtz_ft_trig_inst_name on qrtz_fired_triggers (sched_name, instance_name);
create index idx_qrtz_ft_inst_job_req_rcvry on qrtz_fired_triggers (sched_name, instance_name, requests_recovery);
create index idx_qrtz_ft_j_g on qrtz_fired_triggers (sched_name, job_name, job_group);
create index idx_qrtz_ft_jg on qrtz_fired_triggers (sched_name, job_group);
create index idx_qrtz_ft_t_g on qrtz_fired_triggers (sched_name, trigger_name, trigger_group);
create index idx_qrtz_ft_tg on qrtz_fired_triggers (sched_name, trigger_group);


-- ----------------------------
-- DolphinScheduler Tables
-- ----------------------------

drop table if exists t_ds_access_token;
create table t_ds_access_token
(
    id          int not null,
    user_id     int         default null,
    token       varchar(64) default null,
    expire_time timestamp   default null,
    create_time timestamp   default null,
    update_time timestamp   default null,
    primary key (id)
);

drop table if exists t_ds_alert;
create table t_ds_alert
(
    id                       int                     not null,
    title                    varchar(512) default null,
    sign                     varchar(40)  default '' not null,
    content                  clob,
    alert_status             int          default '0',
    warning_type             int          default '2',
    log                      clob,
    alertgroup_id            int          default null,
    create_time              timestamp    default null,
    update_time              timestamp    default null,
    project_code             bigint       default null,
    workflow_definition_code bigint       default null,
    workflow_instance_id     int          default null,
    alert_type               int          default null,
    primary key (id)
);
create index idx_status on t_ds_alert (alert_status);
create index idx_sign on t_ds_alert (sign);


drop table if exists t_ds_alertgroup;
create table t_ds_alertgroup
(
    id                 int not null,
    alert_instance_ids varchar(255) default null,
    create_user_id     int          default null,
    group_name         varchar(255) default null,
    description        varchar(255) default null,
    create_time        timestamp    default null,
    update_time        timestamp    default null,
    primary key (id),
    constraint t_ds_alertgroup_name_un unique (group_name)
);

drop table if exists t_ds_command;
create table t_ds_command
(
    id                          int    not null,
    command_type                int         default null,
    workflow_definition_code    bigint not null,
    command_param               clob,
    task_depend_type            int         default null,
    failure_strategy            int         default '0',
    warning_type                int         default '0',
    warning_group_id            int         default null,
    schedule_time               timestamp   default null,
    start_time                  timestamp   default null,
    executor_id                 int         default null,
    update_time                 timestamp   default null,
    workflow_instance_priority  int         default '2',
    worker_group                varchar(255),
    tenant_code                 varchar(64) default 'default',
    environment_code            bigint      default '-1',
    dry_run                     int         default '0',
    workflow_instance_id        int         default 0,
    workflow_definition_version int         default 0,
    primary key (id)
);
create index priority_id_index on t_ds_command (workflow_instance_priority, id);


drop table if exists t_ds_serial_command;
create table t_ds_serial_command
(
    id                          int                                 not null,
    workflow_definition_code    bigint                              not null,
    workflow_definition_version int                                 not null,
    workflow_instance_id        bigint                              not null,
    state                       smallint  default 0                 not null,
    command                     clob,
    create_time                 timestamp default current_timestamp not null,
    update_time                 timestamp default current_timestamp not null,
    primary key (id)
);
create index idx_workflow_instance_id_serial on t_ds_serial_command (workflow_instance_id);


drop table if exists t_ds_datasource;
create table t_ds_datasource
(
    id                int         not null,
    name              varchar(64) not null,
    note              varchar(255) default null,
    type              int         not null,
    user_id           int         not null,
    connection_params clob        not null,
    create_time       timestamp   not null,
    update_time       timestamp    default null,
    primary key (id),
    constraint t_ds_datasource_name_un unique (name, type)
);


drop table if exists t_ds_error_command;
create table t_ds_error_command
(
    id                          int    not null,
    command_type                int         default null,
    workflow_definition_code    bigint not null,
    command_param               clob,
    task_depend_type            int         default null,
    failure_strategy            int         default '0',
    warning_type                int         default '0',
    warning_group_id            int         default null,
    schedule_time               timestamp   default null,
    start_time                  timestamp   default null,
    executor_id                 int         default null,
    update_time                 timestamp   default null,
    workflow_instance_priority  int         default '2',
    worker_group                varchar(255),
    tenant_code                 varchar(64) default 'default',
    environment_code            bigint      default '-1',
    dry_run                     int         default '0',
    message                     clob,
    workflow_instance_id        int         default 0,
    workflow_definition_version int         default 0,
    primary key (id)
);


drop table if exists t_ds_workflow_definition;
create table t_ds_workflow_definition
(
    id               int                    not null,
    code             bigint                 not null,
    name             varchar(255) default null,
    version          int          default 1 not null,
    description      clob,
    project_code     bigint       default null,
    release_state    int          default null,
    user_id          int          default null,
    global_params    clob,
    locations        clob,
    warning_group_id int          default null,
    flag             int          default null,
    timeout          int          default '0',
    execution_type   int          default '0',
    create_time      timestamp    default null,
    update_time      timestamp    default null,
    primary key (id),
    constraint workflow_definition_unique unique (name, project_code)
);
create unique index uniq_workflow_definition_code on t_ds_workflow_definition (code);
create index workflow_definition_index_project_code on t_ds_workflow_definition (project_code);


drop table if exists t_ds_workflow_definition_log;
create table t_ds_workflow_definition_log
(
    id               int                      not null,
    code             bigint                   not null,
    name             varchar(255) default null,
    version          int          default '1' not null,
    description      clob,
    project_code     bigint       default null,
    release_state    int          default null,
    user_id          int          default null,
    global_params    clob,
    locations        clob,
    warning_group_id int          default null,
    flag             int          default null,
    timeout          int          default '0',
    execution_type   int          default '0',
    operator         int          default null,
    operate_time     timestamp    default null,
    create_time      timestamp    default null,
    update_time      timestamp    default null,
    primary key (id)
);
create unique index uniq_idx_code_version on t_ds_workflow_definition_log (code, version);
create index workflow_definition_log_index_project_code on t_ds_workflow_definition_log (project_code);


drop table if exists t_ds_task_definition;
create table t_ds_task_definition
(
    id                      int                       not null,
    code                    bigint                    not null,
    name                    varchar(255) default null,
    version                 int          default '1'  not null,
    description             clob,
    project_code            bigint       default null,
    user_id                 int          default null,
    task_type               varchar(50)  default null,
    task_execute_type       int          default '0',
    task_params             clob,
    flag                    int          default null,
    task_priority           int          default '2',
    worker_group            varchar(255) default null,
    environment_code        bigint       default '-1',
    fail_retry_times        int          default null,
    fail_retry_interval     int          default null,
    timeout_flag            int          default null,
    timeout_notify_strategy int          default null,
    timeout                 int          default '0',
    delay_time              int          default '0',
    task_group_id           int          default null,
    task_group_priority     int          default '0',
    resource_ids            clob,
    cpu_quota               int          default '-1' not null,
    memory_max              int          default '-1' not null,
    create_time             timestamp    default null,
    update_time             timestamp    default null,
    primary key (id)
);
create index task_definition_index on t_ds_task_definition (project_code, id);


drop table if exists t_ds_task_definition_log;
create table t_ds_task_definition_log
(
    id                      int                       not null,
    code                    bigint                    not null,
    name                    varchar(255) default null,
    version                 int          default '1'  not null,
    description             clob,
    project_code            bigint       default null,
    user_id                 int          default null,
    task_type               varchar(50)  default null,
    task_execute_type       int          default '0',
    task_params             clob,
    flag                    int          default null,
    task_priority           int          default '2',
    worker_group            varchar(255) default null,
    environment_code        bigint       default '-1',
    fail_retry_times        int          default null,
    fail_retry_interval     int          default null,
    timeout_flag            int          default null,
    timeout_notify_strategy int          default null,
    timeout                 int          default '0',
    delay_time              int          default '0',
    resource_ids            clob,
    operator                int          default null,
    task_group_id           int          default null,
    task_group_priority     int          default '0',
    operate_time            timestamp    default null,
    cpu_quota               int          default '-1' not null,
    memory_max              int          default '-1' not null,
    create_time             timestamp    default null,
    update_time             timestamp    default null,
    primary key (id)
);
create index idx_task_definition_log_code_version on t_ds_task_definition_log (code, version);
create index idx_task_definition_log_project_code on t_ds_task_definition_log (project_code);


drop table if exists t_ds_workflow_task_relation;
create table t_ds_workflow_task_relation
(
    id                          int not null,
    name                        varchar(255) default null,
    project_code                bigint       default null,
    workflow_definition_code    bigint       default null,
    workflow_definition_version int          default null,
    pre_task_code               bigint       default null,
    pre_task_version            int          default '0',
    post_task_code              bigint       default null,
    post_task_version           int          default '0',
    condition_type              int          default null,
    condition_params            clob,
    create_time                 timestamp    default null,
    update_time                 timestamp    default null,
    primary key (id)
);
create index workflow_task_relation_idx_project_code_workflow_definition_code on t_ds_workflow_task_relation (project_code, workflow_definition_code);
create index workflow_task_relation_idx_pre_task_code_version on t_ds_workflow_task_relation (pre_task_code, pre_task_version);
create index workflow_task_relation_idx_post_task_code_version on t_ds_workflow_task_relation (post_task_code, post_task_version);


drop table if exists t_ds_workflow_task_relation_log;
create table t_ds_workflow_task_relation_log
(
    id                          int not null,
    name                        varchar(255) default null,
    project_code                bigint       default null,
    workflow_definition_code    bigint       default null,
    workflow_definition_version int          default null,
    pre_task_code               bigint       default null,
    pre_task_version            int          default '0',
    post_task_code              bigint       default null,
    post_task_version           int          default '0',
    condition_type              int          default null,
    condition_params            clob,
    operator                    int          default null,
    operate_time                timestamp    default null,
    create_time                 timestamp    default null,
    update_time                 timestamp    default null,
    primary key (id)
);
create index workflow_task_relation_log_idx_project_code_workflow_definition_code on t_ds_workflow_task_relation_log (project_code, workflow_definition_code);


drop table if exists t_ds_workflow_instance;
create table t_ds_workflow_instance
(
    id                          int                    not null,
    name                        varchar(255) default null,
    workflow_definition_code    bigint       default null,
    workflow_definition_version int          default 1 not null,
    project_code                bigint       default null,
    state                       int          default null,
    state_history               clob,
    recovery                    int          default null,
    start_time                  timestamp    default null,
    end_time                    timestamp    default null,
    run_times                   int          default null,
    host                        varchar(135) default null,
    command_type                int          default null,
    command_param               clob,
    task_depend_type            int          default null,
    max_try_times               int          default '0',
    failure_strategy            int          default '0',
    warning_type                int          default '0',
    warning_group_id            int          default null,
    schedule_time               timestamp    default null,
    command_start_time          timestamp    default null,
    global_params               clob,
    workflow_instance_json      clob,
    flag                        int          default '1',
    update_time                 timestamp null,
    is_sub_workflow             int          default '0',
    executor_id                 int                    not null,
    executor_name               varchar(64)  default null,
    history_cmd                 clob,
    dependence_schedule_times   clob,
    workflow_instance_priority  int          default '2',
    worker_group                varchar(255),
    environment_code            bigint       default '-1',
    timeout                     int          default '0',
    tenant_code                 varchar(64)  default 'default',
    var_pool                    clob,
    dry_run                     int          default '0',
    next_workflow_instance_id   int          default '0',
    restart_time                timestamp    default null,
    primary key (id)
);
create index workflow_instance_index on t_ds_workflow_instance (workflow_definition_code, id);
create index start_time_index on t_ds_workflow_instance (start_time, end_time);


drop table if exists t_ds_project;
create table t_ds_project
(
    id          int    not null,
    name        varchar(255) default null,
    code        bigint not null,
    description varchar(255) default null,
    user_id     int          default null,
    flag        int          default '1',
    create_time timestamp    default current_timestamp,
    update_time timestamp    default current_timestamp,
    primary key (id)
);
create index user_id_index on t_ds_project (user_id);
create unique index unique_name on t_ds_project (name);
create unique index unique_code on t_ds_project (code);


drop table if exists t_ds_project_parameter;
create table t_ds_project_parameter
(
    id              int          not null,
    param_name      varchar(255) not null,
    param_value     clob         not null,
    param_data_type varchar(50) default 'VARCHAR',
    code            bigint       not null,
    project_code    bigint       not null,
    user_id         int         default null,
    operator        int         default null,
    create_time     timestamp   default current_timestamp,
    update_time     timestamp   default current_timestamp,
    primary key (id)
);
create unique index unique_project_parameter_name on t_ds_project_parameter (project_code, param_name);
create unique index unique_project_parameter_code on t_ds_project_parameter (code);


drop table if exists t_ds_project_preference;
create table t_ds_project_preference
(
    id           int          not null,
    code         bigint       not null,
    project_code bigint       not null,
    preferences  varchar(512) not null,
    user_id      int       default null,
    state        int       default 1,
    create_time  timestamp default current_timestamp,
    update_time  timestamp default current_timestamp,
    primary key (id)
);
create unique index unique_project_preference_project_code on t_ds_project_preference (project_code);
create unique index unique_project_preference_code on t_ds_project_preference (code);


drop table if exists t_ds_queue;
create table t_ds_queue
(
    id          int not null,
    queue_name  varchar(64) default null,
    queue       varchar(64) default null,
    create_time timestamp   default null,
    update_time timestamp   default null,
    primary key (id)
);
create unique index unique_queue_name on t_ds_queue (queue_name);


drop table if exists t_ds_relation_datasource_user;
create table t_ds_relation_datasource_user
(
    id            int not null,
    user_id       int not null,
    datasource_id int       default null,
    perm          int       default '1',
    create_time   timestamp default null,
    update_time   timestamp default null,
    primary key (id)
);


drop table if exists t_ds_relation_workflow_instance;
create table t_ds_relation_workflow_instance
(
    id                          int not null,
    parent_workflow_instance_id int default null,
    parent_task_instance_id     int default null,
    workflow_instance_id        int default null,
    primary key (id)
);
create index idx_relation_workflow_instance_parent_workflow_task on t_ds_relation_workflow_instance (parent_workflow_instance_id, parent_task_instance_id);
create index idx_relation_workflow_instance_workflow_instance_id on t_ds_relation_workflow_instance (workflow_instance_id);


drop table if exists t_ds_relation_project_user;
create table t_ds_relation_project_user
(
    id          int not null,
    user_id     int not null,
    project_id  int       default null,
    perm        int       default '1',
    create_time timestamp default null,
    update_time timestamp default null,
    primary key (id),
    constraint t_ds_relation_project_user_un unique (user_id, project_id)
);
create index relation_project_user_id_index on t_ds_relation_project_user (user_id);


drop table if exists t_ds_relation_resources_user;
create table t_ds_relation_resources_user
(
    id           int not null,
    user_id      int not null,
    resources_id int       default null,
    perm         int       default '1',
    create_time  timestamp default null,
    update_time  timestamp default null,
    primary key (id)
);


drop table if exists t_ds_relation_udfs_user;
create table t_ds_relation_udfs_user
(
    id          int not null,
    user_id     int not null,
    udf_id      int       default null,
    perm        int       default '1',
    create_time timestamp default null,
    update_time timestamp default null,
    primary key (id)
);


drop table if exists t_ds_resources;
create table t_ds_resources
(
    id           int not null,
    alias        varchar(64)  default null,
    file_name    varchar(64)  default null,
    description  varchar(255) default null,
    user_id      int          default null,
    type         int          default null,
    size         bigint       default null,
    create_time  timestamp    default null,
    update_time  timestamp    default null,
    pid          int,
    full_name    varchar(128),
    is_directory tinyint      default 0,
    primary key (id),
    constraint t_ds_resources_un unique (full_name, type)
);


drop table if exists t_ds_schedules;
create table t_ds_schedules
(
    id                         int          not null,
    workflow_definition_code   bigint       not null,
    start_time                 timestamp    not null,
    end_time                   timestamp    not null,
    timezone_id                varchar(40) default null,
    crontab                    varchar(255) not null,
    failure_strategy           int          not null,
    user_id                    int          not null,
    release_state              int          not null,
    warning_type               int          not null,
    warning_group_id           int         default null,
    workflow_instance_priority int         default '2',
    worker_group               varchar(255),
    tenant_code                varchar(64) default 'default',
    environment_code           bigint      default '-1',
    create_time                timestamp    not null,
    update_time                timestamp    not null,
    primary key (id)
);
create unique index uniq_schedules_workflow_definition_code on t_ds_schedules (workflow_definition_code);


drop table if exists t_ds_session;
create table t_ds_session
(
    id              varchar(64) not null,
    user_id         int         default null,
    ip              varchar(45) default null,
    last_login_time timestamp   default null,
    primary key (id)
);


drop table if exists t_ds_task_instance;
create table t_ds_task_instance
(
    id                      int                       not null,
    name                    varchar(255) default null,
    task_type               varchar(50)  default null,
    task_execute_type       int          default '0',
    task_code               bigint                    not null,
    task_definition_version int          default '1'  not null,
    workflow_instance_id    int          default null,
    workflow_instance_name  varchar(255) default null,
    project_code            bigint       default null,
    state                   int          default null,
    submit_time             timestamp    default null,
    start_time              timestamp    default null,
    end_time                timestamp    default null,
    host                    varchar(135) default null,
    execute_path            varchar(200) default null,
    log_path                clob         default null,
    alert_flag              int          default null,
    retry_times             int          default '0',
    pid                     int          default null,
    app_link                clob,
    task_params             clob,
    flag                    int          default '1',
    retry_interval          int          default null,
    max_retry_times         int          default null,
    task_instance_priority  int          default null,
    worker_group            varchar(255),
    environment_code        bigint       default '-1',
    environment_config      clob,
    executor_id             int          default null,
    executor_name           varchar(64)  default null,
    first_submit_time       timestamp    default null,
    delay_time              int          default '0',
    task_group_id           int          default null,
    var_pool                clob,
    dry_run                 int          default '0',
    cpu_quota               int          default '-1' not null,
    memory_max              int          default '-1' not null,
    primary key (id)
);
create index idx_task_instance_code_version on t_ds_task_instance (task_code, task_definition_version);


drop table if exists t_ds_task_instance_context;
create table t_ds_task_instance_context
(
    id               int          not null,
    task_instance_id int          not null,
    "context"        clob         not null,
    context_type     varchar(200) not null,
    create_time      timestamp    not null,
    update_time      timestamp    not null,
    primary key (id)
);
create unique index idx_task_instance_id on t_ds_task_instance_context (task_instance_id, context_type);


drop table if exists t_ds_tenant;
create table t_ds_tenant
(
    id          int not null,
    tenant_code varchar(64)  default null,
    description varchar(255) default null,
    queue_id    int          default null,
    create_time timestamp    default null,
    update_time timestamp    default null,
    primary key (id)
);
create unique index unique_tenant_code on t_ds_tenant (tenant_code);


drop table if exists t_ds_udfs;
create table t_ds_udfs
(
    id            int          not null,
    user_id       int          not null,
    func_name     varchar(255) not null,
    class_name    varchar(255) not null,
    type          int          not null,
    arg_types     varchar(255) default null,
    database_name varchar(255) default null,
    description   varchar(255) default null,
    resource_id   int          not null,
    resource_name varchar(255) not null,
    create_time   timestamp    not null,
    update_time   timestamp    not null,
    primary key (id)
);
create unique index unique_func_name on t_ds_udfs (func_name);


drop table if exists t_ds_user;
create table t_ds_user
(
    id            int not null,
    user_name     varchar(64) default null,
    user_password varchar(64) default null,
    user_type     int         default null,
    email         varchar(64) default null,
    phone         varchar(11) default null,
    tenant_id     int         default -1,
    create_time   timestamp   default null,
    update_time   timestamp   default null,
    queue         varchar(64) default null,
    state         int         default 1,
    time_zone     varchar(32) default null,
    primary key (id)
);

drop table if exists t_ds_version;
create table t_ds_version
(
    id      int         not null,
    version varchar(63) not null,
    primary key (id)
);
create index version_index on t_ds_version (version);


drop table if exists t_ds_worker_group;
create table t_ds_worker_group
(
    id          bigint       not null,
    name        varchar(255) not null,
    addr_list   clob      default null,
    create_time timestamp default null,
    update_time timestamp default null,
    description clob      default null,
    primary key (id),
    constraint name_unique unique (name)
);


drop table if exists t_ds_relation_project_worker_group;
create table t_ds_relation_project_worker_group
(
    id           int          not null,
    project_code bigint    default null,
    worker_group varchar(255) not null,
    create_time  timestamp default null,
    update_time  timestamp default null,
    primary key (id),
    constraint t_ds_relation_project_worker_group_un unique (project_code, worker_group)
);


drop table if exists t_ds_plugin_define;
create table t_ds_plugin_define
(
    id            int          not null,
    plugin_name   varchar(255) not null,
    plugin_type   varchar(63)  not null,
    plugin_params clob null,
    create_time   timestamp null,
    update_time   timestamp null,
    constraint t_ds_plugin_define_pk primary key (id),
    constraint t_ds_plugin_define_un unique (plugin_name, plugin_type)
);


drop table if exists t_ds_alert_plugin_instance;
create table t_ds_alert_plugin_instance
(
    id                     int not null,
    plugin_define_id       int not null,
    plugin_instance_params clob null,
    create_time            timestamp null,
    update_time            timestamp null,
    instance_name          varchar(255) null,
    constraint t_ds_alert_plugin_instance_pk primary key (id)
);


drop table if exists t_ds_environment;
create table t_ds_environment
(
    id          int    not null,
    code        bigint not null,
    name        varchar(255) default null,
    config      clob         default null,
    description clob,
    operator    int          default null,
    create_time timestamp    default null,
    update_time timestamp    default null,
    primary key (id),
    constraint environment_name_unique unique (name),
    constraint environment_code_unique unique (code)
);


drop table if exists t_ds_environment_worker_group_relation;
create table t_ds_environment_worker_group_relation
(
    id               int          not null,
    environment_code bigint       not null,
    worker_group     varchar(255) not null,
    operator         int       default null,
    create_time      timestamp default null,
    update_time      timestamp default null,
    primary key (id),
    constraint environment_worker_group_unique unique (environment_code, worker_group)
);


drop table if exists t_ds_task_group_queue;
create table t_ds_task_group_queue
(
    id                   int not null,
    task_id              int          default null,
    task_name            varchar(255) default null,
    group_id             int          default null,
    workflow_instance_id int          default null,
    priority             int          default '0',
    status               int          default '-1',
    force_start          int          default '0',
    in_queue             int          default '0',
    create_time          timestamp    default null,
    update_time          timestamp    default null,
    primary key (id)
);

create index idx_t_ds_task_group_queue_in_queue on t_ds_task_group_queue (in_queue);
create index idx_t_ds_task_group_queue_task_id on t_ds_task_group_queue (task_id);
create index idx_t_ds_task_group_queue_group_id on t_ds_task_group_queue (group_id);
create index idx_t_ds_task_group_queue_status on t_ds_task_group_queue (status);
create index idx_t_ds_task_group_queue_workflow_instance_id on t_ds_task_group_queue (workflow_instance_id);


drop table if exists t_ds_task_group;
create table t_ds_task_group
(
    id           int not null,
    name         varchar(255) default null,
    description  varchar(255) default null,
    group_size   int not null,
    project_code bigint       default '0',
    use_size     int          default '0',
    user_id      int          default null,
    status       int          default '1',
    create_time  timestamp    default null,
    update_time  timestamp    default null,
    primary key (id)
);


drop table if exists t_ds_audit_log;
create table t_ds_audit_log
(
    id             int          not null,
    user_id        int          not null,
    model_id       bigint       not null,
    model_name     varchar(255) not null,
    model_type     varchar(255) not null,
    operation_type varchar(255) not null,
    description    varchar(255) not null,
    latency        int          not null,
    detail         varchar(255) default null,
    create_time    timestamp    default null,
    primary key (id)
);


drop table if exists t_ds_k8s;
create table t_ds_k8s
(
    id          int not null,
    k8s_name    varchar(255) default null,
    k8s_config  clob,
    create_time timestamp    default null,
    update_time timestamp    default null,
    primary key (id)
);


drop table if exists t_ds_k8s_namespace;
create table t_ds_k8s_namespace
(
    id           int    not null,
    code         bigint not null,
    namespace    varchar(255) default null,
    user_id      int          default null,
    cluster_code bigint not null,
    create_time  timestamp    default null,
    update_time  timestamp    default null,
    primary key (id),
    constraint k8s_namespace_unique unique (namespace, cluster_code)
);


drop table if exists t_ds_relation_namespace_user;
create table t_ds_relation_namespace_user
(
    id           int not null,
    user_id      int       default null,
    namespace_id int       default null,
    perm         int       default null,
    create_time  timestamp default null,
    update_time  timestamp default null,
    primary key (id),
    constraint namespace_user_unique unique (user_id, namespace_id)
);


drop table if exists t_ds_alert_send_status;
create table t_ds_alert_send_status
(
    id                       int not null,
    alert_id                 int not null,
    alert_plugin_instance_id int not null,
    send_status              int       default '0',
    log                      clob,
    create_time              timestamp default null,
    primary key (id),
    constraint alert_send_status_unique unique (alert_id, alert_plugin_instance_id)
);


drop table if exists t_ds_cluster;
create table t_ds_cluster
(
    id          int    not null,
    code        bigint not null,
    name        varchar(255) default null,
    config      clob         default null,
    description clob,
    operator    int          default null,
    create_time timestamp    default null,
    update_time timestamp    default null,
    primary key (id),
    constraint cluster_name_unique unique (name),
    constraint cluster_code_unique unique (code)
);


drop table if exists t_ds_fav_task;
create table t_ds_fav_task
(
    id        int         not null,
    task_type varchar(64) not null,
    user_id   int         not null,
    primary key (id)
);

drop table if exists t_ds_relation_sub_workflow;
create table t_ds_relation_sub_workflow
(
    id                          int    not null,
    parent_workflow_instance_id bigint not null,
    parent_task_code            bigint not null,
    sub_workflow_instance_id    bigint not null,
    primary key (id)
);
create index idx_parent_workflow_instance_id on t_ds_relation_sub_workflow (parent_workflow_instance_id);
create index idx_parent_task_code on t_ds_relation_sub_workflow (parent_task_code);
create index idx_sub_workflow_instance_id on t_ds_relation_sub_workflow (sub_workflow_instance_id);


drop table if exists t_ds_workflow_task_lineage;
create table t_ds_workflow_task_lineage
(
    id                            int    not null,
    workflow_definition_code      bigint not null default 0,
    workflow_definition_version   int    not null default 0,
    task_definition_code          bigint not null default 0,
    task_definition_version       int    not null default 0,
    dept_project_code             bigint not null default 0,
    dept_workflow_definition_code bigint not null default 0,
    dept_task_definition_code     bigint not null default 0,
    create_time                   timestamp       default current_timestamp not null,
    update_time                   timestamp       default current_timestamp not null,
    primary key (id)
);

create index idx_workflow_code_version on t_ds_workflow_task_lineage (workflow_definition_code, workflow_definition_version);
create index idx_task_code_version on t_ds_workflow_task_lineage (task_definition_code, task_definition_version);
create index idx_dept_code on t_ds_workflow_task_lineage (dept_project_code, dept_workflow_definition_code,
                                                          dept_task_definition_code);

drop table if exists t_ds_jdbc_registry_data;
create table t_ds_jdbc_registry_data
(
    id               bigint                              not null,
    data_key         varchar                             not null,
    data_value       clob                                not null,
    data_type        varchar                             not null,
    client_id        bigint                              not null,
    create_time      timestamp default current_timestamp not null,
    last_update_time timestamp default current_timestamp not null,
    primary key (id)
);
create unique index uk_t_ds_jdbc_registry_datakey on t_ds_jdbc_registry_data (data_key);


drop table if exists t_ds_jdbc_registry_lock;
create table t_ds_jdbc_registry_lock
(
    id          bigint                              not null,
    lock_key    varchar                             not null,
    lock_owner  varchar                             not null,
    client_id   bigint                              not null,
    create_time timestamp default current_timestamp not null,
    primary key (id)
);
create unique index uk_t_ds_jdbc_registry_lockkey on t_ds_jdbc_registry_lock (lock_key);


drop table if exists t_ds_jdbc_registry_client_heartbeat;
create table t_ds_jdbc_registry_client_heartbeat
(
    id                  bigint                              not null,
    client_name         varchar                             not null,
    last_heartbeat_time bigint                              not null,
    connection_config   clob                                not null,
    create_time         timestamp default current_timestamp not null,
    primary key (id)
);

drop table if exists t_ds_jdbc_registry_data_change_event;
create table t_ds_jdbc_registry_data_change_event
(
    id                 bigint                              not null,
    event_type         varchar                             not null,
    jdbc_registry_data clob                                not null,
    create_time        timestamp default current_timestamp not null,
    primary key (id)
);

-- ----------------------------
-- SEQUENCES (Creating and Binding to Tables)
-- ----------------------------

-- t_ds_access_token
drop sequence if exists t_ds_access_token_id_sequence;
create sequence t_ds_access_token_id_sequence;
alter table t_ds_access_token MODIFY id default t_ds_access_token_id_sequence.nextval;

-- t_ds_alert
drop sequence if exists t_ds_alert_id_sequence;
create sequence t_ds_alert_id_sequence;
alter table t_ds_alert MODIFY id default t_ds_alert_id_sequence.nextval;

-- t_ds_alertgroup
drop sequence if exists t_ds_alertgroup_id_sequence;
create sequence t_ds_alertgroup_id_sequence;
alter table t_ds_alertgroup MODIFY id default t_ds_alertgroup_id_sequence.nextval;

-- t_ds_command
drop sequence if exists t_ds_command_id_sequence;
create sequence t_ds_command_id_sequence;
alter table t_ds_command MODIFY id default t_ds_command_id_sequence.nextval;

-- t_ds_datasource
drop sequence if exists t_ds_datasource_id_sequence;
create sequence t_ds_datasource_id_sequence;
alter table t_ds_datasource MODIFY id default t_ds_datasource_id_sequence.nextval;

-- t_ds_workflow_definition
drop sequence if exists t_ds_workflow_definition_id_sequence;
create sequence t_ds_workflow_definition_id_sequence;
alter table t_ds_workflow_definition MODIFY id default t_ds_workflow_definition_id_sequence.nextval;

-- t_ds_workflow_definition_log
drop sequence if exists t_ds_workflow_definition_log_id_sequence;
create sequence t_ds_workflow_definition_log_id_sequence;
alter table t_ds_workflow_definition_log MODIFY id default t_ds_workflow_definition_log_id_sequence.nextval;

-- t_ds_task_definition
drop sequence if exists t_ds_task_definition_id_sequence;
create sequence t_ds_task_definition_id_sequence;
alter table t_ds_task_definition MODIFY id default t_ds_task_definition_id_sequence.nextval;

-- t_ds_task_definition_log
drop sequence if exists t_ds_task_definition_log_id_sequence;
create sequence t_ds_task_definition_log_id_sequence;
alter table t_ds_task_definition_log MODIFY id default t_ds_task_definition_log_id_sequence.nextval;

-- t_ds_workflow_task_relation
drop sequence if exists t_ds_workflow_task_relation_id_sequence;
create sequence t_ds_workflow_task_relation_id_sequence;
alter table t_ds_workflow_task_relation MODIFY id default t_ds_workflow_task_relation_id_sequence.nextval;

-- t_ds_workflow_task_relation_log
drop sequence if exists t_ds_workflow_task_relation_log_id_sequence;
create sequence t_ds_workflow_task_relation_log_id_sequence;
alter table t_ds_workflow_task_relation_log MODIFY id default t_ds_workflow_task_relation_log_id_sequence.nextval;

-- t_ds_workflow_instance
drop sequence if exists t_ds_workflow_instance_id_sequence;
create sequence t_ds_workflow_instance_id_sequence;
alter table t_ds_workflow_instance MODIFY id default t_ds_workflow_instance_id_sequence.nextval;

-- t_ds_project
drop sequence if exists t_ds_project_id_sequence;
create sequence t_ds_project_id_sequence;
alter table t_ds_project MODIFY id default t_ds_project_id_sequence.nextval;

-- t_ds_queue
drop sequence if exists t_ds_queue_id_sequence;
create sequence t_ds_queue_id_sequence;
alter table t_ds_queue MODIFY id default t_ds_queue_id_sequence.nextval;

-- t_ds_relation_datasource_user
drop sequence if exists t_ds_relation_datasource_user_id_sequence;
create sequence t_ds_relation_datasource_user_id_sequence;
alter table t_ds_relation_datasource_user MODIFY id default t_ds_relation_datasource_user_id_sequence.nextval;

-- t_ds_relation_workflow_instance
drop sequence if exists t_ds_relation_workflow_instance_id_sequence;
create sequence t_ds_relation_workflow_instance_id_sequence;
alter table t_ds_relation_workflow_instance MODIFY id default t_ds_relation_workflow_instance_id_sequence.nextval;

-- t_ds_relation_project_user
drop sequence if exists t_ds_relation_project_user_id_sequence;
create sequence t_ds_relation_project_user_id_sequence;
alter table t_ds_relation_project_user MODIFY id default t_ds_relation_project_user_id_sequence.nextval;

-- t_ds_relation_resources_user
drop sequence if exists t_ds_relation_resources_user_id_sequence;
create sequence t_ds_relation_resources_user_id_sequence;
alter table t_ds_relation_resources_user MODIFY id default t_ds_relation_resources_user_id_sequence.nextval;

-- t_ds_relation_udfs_user
drop sequence if exists t_ds_relation_udfs_user_id_sequence;
create sequence t_ds_relation_udfs_user_id_sequence;
alter table t_ds_relation_udfs_user MODIFY id default t_ds_relation_udfs_user_id_sequence.nextval;

-- t_ds_resources
drop sequence if exists t_ds_resources_id_sequence;
create sequence t_ds_resources_id_sequence;
alter table t_ds_resources MODIFY id default t_ds_resources_id_sequence.nextval;

-- t_ds_schedules
drop sequence if exists t_ds_schedules_id_sequence;
create sequence t_ds_schedules_id_sequence;
alter table t_ds_schedules MODIFY id default t_ds_schedules_id_sequence.nextval;

-- t_ds_task_instance
drop sequence if exists t_ds_task_instance_id_sequence;
create sequence t_ds_task_instance_id_sequence;
alter table t_ds_task_instance MODIFY id default t_ds_task_instance_id_sequence.nextval;

-- t_ds_tenant
drop sequence if exists t_ds_tenant_id_sequence;
create sequence t_ds_tenant_id_sequence;
alter table t_ds_tenant MODIFY id default t_ds_tenant_id_sequence.nextval;

-- t_ds_udfs
drop sequence if exists t_ds_udfs_id_sequence;
create sequence t_ds_udfs_id_sequence;
alter table t_ds_udfs MODIFY id default t_ds_udfs_id_sequence.nextval;

-- t_ds_user
drop sequence if exists t_ds_user_id_sequence;
create sequence t_ds_user_id_sequence;
alter table t_ds_user MODIFY id default t_ds_user_id_sequence.nextval;

-- t_ds_version
drop sequence if exists t_ds_version_id_sequence;
create sequence t_ds_version_id_sequence;
alter table t_ds_version
    alter column id set default t_ds_version_id_sequence.nextval;

-- t_ds_worker_group
drop sequence if exists t_ds_worker_group_id_sequence;
create sequence t_ds_worker_group_id_sequence;
alter table t_ds_worker_group MODIFY id default t_ds_worker_group_id_sequence.nextval;

-- t_ds_project_parameter
drop sequence if exists t_ds_project_parameter_id_sequence;
create sequence t_ds_project_parameter_id_sequence;
alter table t_ds_project_parameter MODIFY id default t_ds_project_parameter_id_sequence.nextval;

-- t_ds_project_preference
drop sequence if exists t_ds_project_preference_id_sequence;
create sequence t_ds_project_preference_id_sequence;
alter table t_ds_project_preference MODIFY id default t_ds_project_preference_id_sequence.nextval;

-- t_ds_relation_project_worker_group
drop sequence if exists t_ds_relation_project_worker_group_sequence;
create sequence t_ds_relation_project_worker_group_sequence;
alter table t_ds_relation_project_worker_group MODIFY id default t_ds_relation_project_worker_group_sequence.nextval;

-- t_ds_serial_command
drop sequence if exists t_ds_serial_command_id_sequence;
create sequence t_ds_serial_command_id_sequence;
alter table t_ds_serial_command MODIFY id default t_ds_serial_command_id_sequence.nextval;

-- t_ds_plugin_define
drop sequence if exists t_ds_plugin_define_id_sequence;
create sequence t_ds_plugin_define_id_sequence;
alter table t_ds_plugin_define MODIFY id default t_ds_plugin_define_id_sequence.nextval;

-- t_ds_alert_plugin_instance
drop sequence if exists t_ds_alert_plugin_instance_id_sequence;
create sequence t_ds_alert_plugin_instance_id_sequence;
alter table t_ds_alert_plugin_instance MODIFY id default t_ds_alert_plugin_instance_id_sequence.nextval;

-- t_ds_environment
drop sequence if exists t_ds_environment_id_sequence;
create sequence t_ds_environment_id_sequence;
alter table t_ds_environment MODIFY id default t_ds_environment_id_sequence.nextval;

-- t_ds_environment_worker_group_relation
drop sequence if exists t_ds_environment_worker_group_relation_id_sequence;
create sequence t_ds_environment_worker_group_relation_id_sequence;
alter table t_ds_environment_worker_group_relation MODIFY id default t_ds_environment_worker_group_relation_id_sequence.nextval;

-- t_ds_task_group_queue
drop sequence if exists t_ds_task_group_queue_id_sequence;
create sequence t_ds_task_group_queue_id_sequence;
alter table t_ds_task_group_queue MODIFY id default t_ds_task_group_queue_id_sequence.nextval;

-- t_ds_task_group
drop sequence if exists t_ds_task_group_id_sequence;
create sequence t_ds_task_group_id_sequence;
alter table t_ds_task_group MODIFY id default t_ds_task_group_id_sequence.nextval;

-- t_ds_audit_log
drop sequence if exists t_ds_audit_log_id_sequence;
create sequence t_ds_audit_log_id_sequence;
alter table t_ds_audit_log MODIFY id default t_ds_audit_log_id_sequence.nextval;

-- t_ds_k8s
drop sequence if exists t_ds_k8s_id_sequence;
create sequence t_ds_k8s_id_sequence;
alter table t_ds_k8s MODIFY id default t_ds_k8s_id_sequence.nextval;

-- t_ds_k8s_namespace
drop sequence if exists t_ds_k8s_namespace_id_sequence;
create sequence t_ds_k8s_namespace_id_sequence;
alter table t_ds_k8s_namespace MODIFY id default t_ds_k8s_namespace_id_sequence.nextval;

-- t_ds_relation_namespace_user
drop sequence if exists t_ds_relation_namespace_user_id_sequence;
create sequence t_ds_relation_namespace_user_id_sequence;
alter table t_ds_relation_namespace_user MODIFY id default t_ds_relation_namespace_user_id_sequence.nextval;

-- t_ds_alert_send_status
drop sequence if exists t_ds_alert_send_status_id_sequence;
create sequence t_ds_alert_send_status_id_sequence;
alter table t_ds_alert_send_status MODIFY id default t_ds_alert_send_status_id_sequence.nextval;

-- t_ds_cluster
drop sequence if exists t_ds_cluster_id_sequence;
create sequence t_ds_cluster_id_sequence;
alter table t_ds_cluster MODIFY id default t_ds_cluster_id_sequence.nextval;

-- t_ds_fav_task
drop sequence if exists t_ds_fav_task_id_sequence;
create sequence t_ds_fav_task_id_sequence;
alter table t_ds_fav_task MODIFY id default t_ds_fav_task_id_sequence.nextval;

-- t_ds_relation_sub_workflow
drop sequence if exists t_ds_relation_sub_workflow_id_sequence;
create sequence t_ds_relation_sub_workflow_id_sequence;
alter table t_ds_relation_sub_workflow MODIFY id default t_ds_relation_sub_workflow_id_sequence.nextval;

-- t_ds_workflow_task_lineage
drop sequence if exists t_ds_workflow_task_lineage_id_sequence;
create sequence t_ds_workflow_task_lineage_id_sequence;
alter table t_ds_workflow_task_lineage MODIFY id default t_ds_workflow_task_lineage_id_sequence.nextval;

-- t_ds_task_instance_context
drop sequence if exists t_ds_task_instance_context_id_sequence;
create sequence t_ds_task_instance_context_id_sequence;
alter table t_ds_task_instance_context MODIFY id default t_ds_task_instance_context_id_sequence.nextval;

-- t_ds_jdbc_registry_data
drop sequence if exists t_ds_jdbc_registry_data_id_sequence;
create sequence t_ds_jdbc_registry_data_id_sequence;
alter table t_ds_jdbc_registry_data MODIFY id default t_ds_jdbc_registry_data_id_sequence.nextval;

-- t_ds_jdbc_registry_lock
drop sequence if exists t_ds_jdbc_registry_lock_id_sequence;
create sequence t_ds_jdbc_registry_lock_id_sequence;
alter table t_ds_jdbc_registry_lock MODIFY id default t_ds_jdbc_registry_lock_id_sequence.nextval;

-- t_ds_jdbc_registry_data_change_event
drop sequence if exists t_ds_jdbc_registry_data_change_event_id_seq;
create sequence t_ds_jdbc_registry_data_change_event_id_seq;
alter table t_ds_jdbc_registry_data_change_event MODIFY id default t_ds_jdbc_registry_data_change_event_id_seq.nextval;

-- ----------------------------
-- INITIAL DATA
-- ----------------------------

-- Records of t_ds_user?user : admin , password : dolphinscheduler123
insert into t_ds_user(user_name, user_password, user_type, email, phone, tenant_id, state, create_time, update_time,
                      time_zone)
values ('admin', '7ad2410b2f4c074479a8937a28a22b8f', '0', 'xxx@qq.com', '', '-1', 1, '2018-03-27 15:48:50',
        '2018-10-24 17:40:22', null);

-- Records of t_ds_tenant
insert into t_ds_tenant(id, tenant_code, description, queue_id, create_time, update_time)
values (-1, 'default', 'default tenant', '1', '2018-03-27 15:48:50', '2018-10-24 17:40:22');

-- Records of t_ds_alertgroup, default admin warning group
insert into t_ds_alertgroup(alert_instance_ids, create_user_id, group_name, description, create_time, update_time)
values (null, 1, 'default admin warning group', 'default admin warning group', '2018-11-29 10:20:39',
        '2018-11-29 10:20:39');

-- Records of t_ds_queue,default queue name : default
insert into t_ds_queue(queue_name, queue, create_time, update_time)
values ('default', 'default', '2018-11-29 10:22:33', '2018-11-29 10:22:33');

-- Records of t_ds_version
insert into t_ds_version(version)
values ('3.4.0');
