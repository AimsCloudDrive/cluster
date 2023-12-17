start slave;

stop slave;

reset slave;

change master TO 
master_host='',
master_port=3306,
master_user='slave',
master_password='123456',
master_log_file='',
master_log_pos=,
get_master_public_key=1;

start slave;

show slave status \G;