### 给.yml文件赋予可执行权限
	
	chmod u+x docker-compose_mysql-cluster.yml

### 执行.yml文件
	
	docker-compose -f docker-compose_mysql-cluster.yml up -d

### 进入mysql_master容器并登录，默认密码123456，可在.yml文件中修改
	
	docker exec -it mysql_master mysql -uroot -p123456

### 修改用户slave的登录IP
	
	use mysql;
	
	update user set host='%' where user='slave';

### 给用户slave赋予权限
	
	grant all privileges on business.* to 'slave'@'%';
	
	刷新权限
	
	plush privileges;

### 查看master状态
	
	show master status;

### 记住file和position

### 返回当前目录
	
	exit

### 修改ms目录下的文件master_slave.sql
	
	vim ./ms/master_slave.sql

	修改master_host为自己的IP地址，master_log_file和master_log_pos为之前查询到的file和position的值

	保存退出
	
	esc按键  :(英文冒号)wq  回车

### 分别进入容器mysql_slave01,mysql_slave02,mysql_slave03,默认密码123456
	
	docker exec -it mysql_slave01 mysql -uroot -p123456
	
#### 运行SQL脚本master_slave.sql
	
	source /etc/ms/master_slave.sql
	
	exit

### 测试

#### 进入容器mysql_master
		
		docker exec -it mysql_master mysql -uroot -p123456
		
		use business;
		
		
		create table business.test(test varchar(10) default "test")engine=Innodb,defaultchrset=utf8mb4;
		
		show tables;
		
		看到已经创建好了test退出
		
		exit
	
#### 进入每个slave容器
		docker exec -it mysql_slave01 mysql -uroot -p123456
		
		use business;
		
		show tables;
		
		看到同样有test表即表明主从复制配置成功

### 进入mysql_master容器，修改密码插件
	
	docker exec -it mysql_master mysql -uroot -p123456
	
	alter user 'slave'@'%' identified with mysql_native_password by '123456';