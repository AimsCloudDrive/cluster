```txt
# Redis configuration file example.
# 启动redis的时候，必须按照这种方法启动服务
# ./redis-server /path/to/redis.conf

# Note on units: when memory size is needed, it is possible to specify
# it in the usual form of 1k 5GB 4M and so forth:
#
# 1k => 1000 bytes
# 1kb => 1024 bytes
# 1m => 1000000 bytes
# 1mb => 1024*1024 bytes
# 1g => 1000000000 bytes
# 1gb => 1024*1024*1024 bytes
#
# units are case insensitive so 1GB 1Gb 1gB are all the same.

################################## INCLUDES ###################################

# 通过一个注册配置文件去Include你自定义的配置文件，引用方法如下
# include /path/to/local.conf
# include /path/to/other.conf

################################## NETWORK #####################################

# 绑定你的redis-server的可访问的IP地址
bind 0.0.0.0

# 开启保护模式，目的是为了其他客户端不能够非法得访问我的redis服务
protected-mode yes

#配置redis-server的端口
port 6379

# TCP listen() backlog.
# 当redis-server面临高并发的时候，他将一部分的连接请求存入backlog的日志中，从而避免高挤压
tcp-backlog 511

# Unix socket.
#配置显示的显示出redis服务的socket的配置文件，如果没有配置，就没有这个文件
# unixsocket /tmp/redis.sock
# unixsocketperm 700

# 服务端和客户端断开连接的最大多的超时时间
timeout 0

# 配置每五分钟汇报一次当前服务端的状态
tcp-keepalive 300

################################# GENERAL #####################################

# 开启后台启动
daemonize yes

# 如果你使用了外部组件(supervised)来控制你的redis的启动，你就要选择这个下面的选项来控制
supervised no

# redis-server的进程文件的生成路径
pidfile /var/run/redis_6379.pid

# 指定你的日志级别：从以下4中模式选择
# debug 最多日志的提示，一般在开发环境下使用
# verbose 在测试环境下可以使用这个模式
# notice 日志提示相对较少，一般只提示一些启动关闭等关键信息，一般在生产环境中使用
# warning 只有非常重要的日志才会被记录
loglevel notice

# 指定redis-server的日志的路径
logfile ""

# 设置你的数据库的数量
databases 16

################################ SNAPSHOTTING  ################################
# 将数据库保存在磁盘的策略：RDB
# 以下配置含义：
# 900秒(15分钟)完成了至少一次写操作，就将数据保存在磁盘中
# 300秒(5分钟)完成至少10次此操作
# 1分钟之内至少完成3次此操作
#   save ""

save 900 1
save 300 10
save 60 3

# 配置的作用是，当你的后台RDB进行日志持久化的时候，如果持久化快照失败，
# 你的redis的服务将不再允许进行数据保存。因为普通状态下我们的开发者很难
# 观察到日志快照失败，它通过停止写操作来强制使开发注意到日志保存失效的。
# 如果你的日志又可以保存成功的情况下，自动允许写入
stop-writes-on-bgsave-error yes

# 设置使用LZF算法对持久化数据进行压缩，但是压缩会非常消耗CPU性能，但是文件
# 的体积可以得到缩减
rdbcompression yes

# 在压缩完成之后，redis还恶意使用CRC64算法校验你保存文件完整性。
# 但是这个做法会让你多牺牲10%性能
rdbchecksum yes

# 持久化文件名称
dbfilename dump.rdb

# 持久化文件路径
dir /opt/apps/redis-3.2.8/

################################# REPLICATION #################################

# 这个命令使用于连接redis服务中的主节点的命令
# slaveof <masterip> <masterport>


# 使用主机授权
# masterauth <master-password>

# 当你的从机连接主机做主从复制的时候，如果失败。
# 1.yes的策略将会使salve重新向master请求;
# 2.no的策略发送 要给错误信息给主
slave-serve-stale-data yes

# 配置主从复制，读写分离。从机只读
slave-read-only yes

# 同步策略：本地磁盘同步，无盘同步：Socket
# yes:表示使用无盘同步，no表示有磁盘同步
repl-diskless-sync no

# 当开启无盘同步配置的最大延迟时间(s)
repl-diskless-sync-delay 5

# 从服务器以预定的间隔向服务器发送ping,可以使用replping从time选项更改此间隔。默认是间隔秒
# repl-ping-slave-period 10

# The following option sets the replication timeout for:
#
# 1) Bulk transfer I/O during SYNC, from the point of view of slave.
# 2) Master timeout from the point of view of slaves (data, pings).
# 3) Slave timeout from the point of view of masters (REPLCONF ACK pings).
#
# It is important to make sure that this value is greater than the value
# specified for repl-ping-slave-period otherwise a timeout will be detected
# every time there is low traffic between the master and the slave.
# 以下选项是设置超时时间：
# 1>同步期间的大容量传输I/O，从slaves角度看
# 2>主节点超时时间，从slaves(数据，pings)角度看
# 3>从结点超时时间，从主节点角度看
#   需要注意的是，这个时间点的设置应该大于repl-ping-slave-period的设置，
# 否则会每次都被检测到主从结点之间的通信量很低
# repl-timeout 60

#   配置从机延迟带宽。yes的时候，会减少带宽这将增加从机的数据延迟度。
# no的话就会降低从机的数据延迟。但是选择yes的好处是我们将主从复制的带宽减少，
# 这些带宽更多的是用于写操作。所以当你的集群面对海量的数据写入的时候，
# 选择yes是一个good idea
repl-disable-tcp-nodelay no

#   配置的是当你的从机断开了与主机连接，从机一旦断开连接，这个从机重启之后就
# 没有主机的数据了。这个时候从机需要重新同步，但是由于我们之前同步过，如果每次
# 都要从头再来，成本太大了。backlog，我们可以通过这个backlog进行同步恢复，
# 通过它，我只需要同步我宕机之后的那一部分新的数据。
# repl-backlog-size 1mb

# 当主节点在一段时间内不再连接从结点时，将释放挤压。下面的选项设置了从最后一个从连接断开
# 开始释放待定缓冲区所需的秒数。
# 值为0时表示永远不会发布待办事项安排
# repl-backlog-ttl 3600

# slave优先级是由Redis在INFO输出中发布的整数
# 优先级状态表示被选为master的可能性的高低
# 缺省情况下，优先级为100
slave-priority 100

# min-slaves-to-write表示至少有N个从服务器，必须处于online状态。
# min-slaves-max-lag表示以秒为单位的从节点的延迟时间，从从服务器接收到的最后一个ping，通过每秒发送一次
# 例如：需要至少三个slave，并且延迟<=10秒使用
# 将其中一个设置为0，表示禁用该特性
# 默认情况下min-slaves-to-write设置为0(特性禁用),min-slaves-max-lag设置为10
# min-slaves-to-write 3
# min-slaves-max-lag 10

# 从机通常上报的IP地址是通过以下方法获得：
# IP：通过检查从端与主端连接所用的套接字的对端地址来自动检测该地址
# 端口：复制握手期间由从端通信的端口，通常是从端用于列出连接的端口
# 然而，当算口转发或网络地址转换NAT被使用的时候，slave实际可能通过不同的IP和端口对可达。
# 从服务器可以使用以下两个选项向主服务器报告一组特定的IP和端口，这样的INOF和ROLE都将报告这些值
# 如果只需要覆盖端口或IP地址，则不需要同时使用这两个选项
# slave-announce-ip 5.5.5.5
# slave-announce-port 1234

################################## SECURITY ###################################

# 要求客户端在处理任何其他命令之前发出AUTH<PASSWORD>。这在你不信任的环境中可能很有用，
# 其他具有访问运行redis-server的主机的权限
# 为了向后兼容，这应该被注释掉，因为大多数人不需要认证(因为他们一般是运行自己的服务器)
# 警告：因为redis是相当快的，每秒查询15万个密码队，这意味着应该设置一个非常强的密码，
# 否则将会被很容易的破解。
# requirepass foobared

# 命令重命名：
# 在共享环境中可以更改危险命令的名称。例如：CONFIG可以被更改为一些难以置信的东西。
# 即使这样它依旧可以应用于内部，但是不能用于普通的客户端
# 例如：
# rename-command CONFIG b840fc02d524045429941cc15f59e41cb7be6c52
#
# 也可以通过命令重命名为空字符串来完全终止命令：
# rename-command CONFIG ""
#
# 需要注意的是，更改登录到AOF文件或传输到从服务器的命令可能会导致严重的问题
################################### LIMITS ####################################

# 设置同时连接的客户端的最大数量，默认情况下，这个限制被设置为10000个客户端。
# 但是如果Redis服务器不能配置进程文件限制。允许的最大客户数量被设置为当前的文件限制
# 一旦达到限制，Redis将关闭并发送”最大客户端数量达到限制“的错误的新连接
# maxclients 10000

# 不要使用超过指定字节数的内存。当达到内存限制时，Redis将根据所选的回收策略尝试删除键(参见maxmemory-policy)。

# 如果Redis不能根据策略删除键，或者如果策略设置为“noeviction”。Redis将开始对使用更多内存的命令(如SET、LPUSH等)进行错误回复，
# 并继续对只读命令(如GET)进行回复当使用Redis作为LRU缓存时，这个选项通常很有用，或者为一个实例设置硬内存限制(使用'noeviction'策略)警告:
# 如果你有一个附加到一个实例maxmemory上的slave，需要从使用的内存计数中减去输出缓冲区的大小，因此网络问题/ resync将不触发一个循环，
# 其中键被逐出，并依次输出从服务器的缓冲区被键的del所填满，触发删除更多键，
# 以此类推，直到数据库被完全清空总之……如果你有附加的奴隶，建议你为maxmemory设置一个下限，
# 以便在系统上有一些空闲RAM用于从输出缓冲区(但如果策略是'noeviction'，这是不需要的)最大记忆<bytes>
# maxmemory <bytes>

# 当内存使用已经达到上限的时候，选择以下机制：

# volatile-lru -> 使用LRU算法删除带有过期集合
# allkeys-lru -> 根据LRU算法删除任意一个密钥
# volatile-random -> 删除一个过期的随机密钥
# allkeys-random -> 移除一个随机的任何的密钥
# volatile-ttl -> 移除一个最近过期的密钥
# noeviction -> 根本不过期，只是在写操作时返回一个错误
# 默认选项：
# maxmemory-policy noeviction

# LRU和最小TTL算法不是精确的算法，而是近似的算法(为了节省内存)，因此你可以选择
# 调整他的精度或者速度，对于默认的redis将检查5个键，并选择一个最近很少使用的，你可以改变样本大小使用以下配置指令
#
# 默认的5可以产生足够好的结果，10非常接近真实的LRU，但是花费更多的CPU，3是非常快，但不是非常精确
#
# maxmemory-samples 5

############################## APPEND ONLY MODE ###############################

# AOF的持久化方式是它通过将所有的向redis的写操作记录到日志中的形式来帮助我们进行数据
# 的恢复。我可以每1秒中记录一次，也可以每一次写操作都记录。但是这个模式默认是关闭的
# 所以需要我们手动的开启。在生产环境中我们一般都是RDB和AOF一起配合使用
appendonly yes

# 指定AOF的日志文件的名称

appendfilename "appendonly.aof"

# 配置AOF同步日志的策略
# appendfsync always ## 每一次写操作都记录日志
appendfsync everysec ## 每一秒记录日志
# appendfsync no ## 不记录

# When the AOF fsync policy is set to always or everysec, and a background
# saving process (a background save or AOF log background rewriting) is
# performing a lot of I/O against the disk, in some Linux configurations
# Redis may block too long on the fsync() call. Note that there is no fix for
# this currently, as even performing fsync in a different thread will block
# our synchronous write(2) call.
#
# In order to mitigate this problem it's possible to use the following option
# that will prevent fsync() from being called in the main process while a
# BGSAVE or BGREWRITEAOF is in progress.
#
# This means that while another child is saving, the durability of Redis is
# the same as "appendfsync none". In practical terms, this means that it is
# possible to lose up to 30 seconds of log in the worst scenario (with the
# default Linux settings).
#
# If you have latency problems turn this to "yes". Otherwise leave it as
# "no" that is the safest pick from the point of view of durability.

no-appendfsync-on-rewrite no

# Automatic rewrite of the append only file.
# Redis is able to automatically rewrite the log file implicitly calling
# BGREWRITEAOF when the AOF log size grows by the specified percentage.
#
# This is how it works: Redis remembers the size of the AOF file after the
# latest rewrite (if no rewrite has happened since the restart, the size of
# the AOF at startup is used).
#
# This base size is compared to the current size. If the current size is
# bigger than the specified percentage, the rewrite is triggered. Also
# you need to specify a minimal size for the AOF file to be rewritten, this
# is useful to avoid rewriting the AOF file even if the percentage increase
# is reached but it is still pretty small.
#
# Specify a percentage of zero in order to disable the automatic AOF
# rewrite feature.

auto-aof-rewrite-percentage 100
auto-aof-rewrite-min-size 64mb

# An AOF file may be found to be truncated at the end during the Redis
# startup process, when the AOF data gets loaded back into memory.
# This may happen when the system where Redis is running
# crashes, especially when an ext4 filesystem is mounted without the
# data=ordered option (however this can't happen when Redis itself
# crashes or aborts but the operating system still works correctly).
#
# Redis can either exit with an error when this happens, or load as much
# data as possible (the default now) and start if the AOF file is found
# to be truncated at the end. The following option controls this behavior.
#
# If aof-load-truncated is set to yes, a truncated AOF file is loaded and
# the Redis server starts emitting a log to inform the user of the event.
# Otherwise if the option is set to no, the server aborts with an error
# and refuses to start. When the option is set to no, the user requires
# to fix the AOF file using the "redis-check-aof" utility before to restart
# the server.
#
# Note that if the AOF file will be found to be corrupted in the middle
# the server will still exit with an error. This option only applies when
# Redis will try to read more data from the AOF file but not enough bytes
# will be found.
aof-load-truncated yes

################################ LUA SCRIPTING  ###############################

# Max execution time of a Lua script in milliseconds.
#
# If the maximum execution time is reached Redis will log that a script is
# still in execution after the maximum allowed time and will start to
# reply to queries with an error.
#
# When a long running script exceeds the maximum execution time only the
# SCRIPT KILL and SHUTDOWN NOSAVE commands are available. The first can be
# used to stop a script that did not yet called write commands. The second
# is the only way to shut down the server in the case a write command was
# already issued by the script but the user doesn't want to wait for the natural
# termination of the script.
#
# Set it to 0 or a negative value for unlimited execution without warnings.
lua-time-limit 5000

################################ REDIS CLUSTER  ###############################
#
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# WARNING EXPERIMENTAL: Redis Cluster is considered to be stable code, however
# in order to mark it as "mature" we need to wait for a non trivial percentage
# of users to deploy it in production.
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#
# Normal Redis instances can't be part of a Redis Cluster; only nodes that are
# started as cluster nodes can. In order to start a Redis instance as a
# cluster node enable the cluster support uncommenting the following:
#
# cluster-enabled yes

# Every cluster node has a cluster configuration file. This file is not
# intended to be edited by hand. It is created and updated by Redis nodes.
# Every Redis Cluster node requires a different cluster configuration file.
# Make sure that instances running in the same system do not have
# overlapping cluster configuration file names.
#
# cluster-config-file nodes-6379.conf

# Cluster node timeout is the amount of milliseconds a node must be unreachable
# for it to be considered in failure state.
# Most other internal time limits are multiple of the node timeout.
#
# cluster-node-timeout 15000

# A slave of a failing master will avoid to start a failover if its data
# looks too old.
#
# There is no simple way for a slave to actually have a exact measure of
# its "data age", so the following two checks are performed:
#
# 1) If there are multiple slaves able to failover, they exchange messages
#    in order to try to give an advantage to the slave with the best
#    replication offset (more data from the master processed).
#    Slaves will try to get their rank by offset, and apply to the start
#    of the failover a delay proportional to their rank.
#
# 2) Every single slave computes the time of the last interaction with
#    its master. This can be the last ping or command received (if the master
#    is still in the "connected" state), or the time that elapsed since the
#    disconnection with the master (if the replication link is currently down).
#    If the last interaction is too old, the slave will not try to failover
#    at all.
#
# The point "2" can be tuned by user. Specifically a slave will not perform
# the failover if, since the last interaction with the master, the time
# elapsed is greater than:
#
#   (node-timeout * slave-validity-factor) + repl-ping-slave-period
#
# So for example if node-timeout is 30 seconds, and the slave-validity-factor
# is 10, and assuming a default repl-ping-slave-period of 10 seconds, the
# slave will not try to failover if it was not able to talk with the master
# for longer than 310 seconds.
#
# A large slave-validity-factor may allow slaves with too old data to failover
# a master, while a too small value may prevent the cluster from being able to
# elect a slave at all.
#
# For maximum availability, it is possible to set the slave-validity-factor
# to a value of 0, which means, that slaves will always try to failover the
# master regardless of the last time they interacted with the master.
# (However they'll always try to apply a delay proportional to their
# offset rank).
#
# Zero is the only value able to guarantee that when all the partitions heal
# the cluster will always be able to continue.
#
# cluster-slave-validity-factor 10

# Cluster slaves are able to migrate to orphaned masters, that are masters
# that are left without working slaves. This improves the cluster ability
# to resist to failures as otherwise an orphaned master can't be failed over
# in case of failure if it has no working slaves.
#
# Slaves migrate to orphaned masters only if there are still at least a
# given number of other working slaves for their old master. This number
# is the "migration barrier". A migration barrier of 1 means that a slave
# will migrate only if there is at least 1 other working slave for its master
# and so forth. It usually reflects the number of slaves you want for every
# master in your cluster.
#
# Default is 1 (slaves migrate only if their masters remain with at least
# one slave). To disable migration just set it to a very large value.
# A value of 0 can be set but is useful only for debugging and dangerous
# in production.
#
# cluster-migration-barrier 1

# By default Redis Cluster nodes stop accepting queries if they detect there
# is at least an hash slot uncovered (no available node is serving it).
# This way if the cluster is partially down (for example a range of hash slots
# are no longer covered) all the cluster becomes, eventually, unavailable.
# It automatically returns available as soon as all the slots are covered again.
#
# However sometimes you want the subset of the cluster which is working,
# to continue to accept queries for the part of the key space that is still
# covered. In order to do so, just set the cluster-require-full-coverage
# option to no.
#
# cluster-require-full-coverage yes

# In order to setup your cluster make sure to read the documentation
# available at http://redis.io web site.

################################## SLOW LOG ###################################

# The Redis Slow Log is a system to log queries that exceeded a specified
# execution time. The execution time does not include the I/O operations
# like talking with the client, sending the reply and so forth,
# but just the time needed to actually execute the command (this is the only
# stage of command execution where the thread is blocked and can not serve
# other requests in the meantime).
#
# You can configure the slow log with two parameters: one tells Redis
# what is the execution time, in microseconds, to exceed in order for the
# command to get logged, and the other parameter is the length of the
# slow log. When a new command is logged the oldest one is removed from the
# queue of logged commands.

# The following time is expressed in microseconds, so 1000000 is equivalent
# to one second. Note that a negative number disables the slow log, while
# a value of zero forces the logging of every command.
slowlog-log-slower-than 10000

# There is no limit to this length. Just be aware that it will consume memory.
# You can reclaim memory used by the slow log with SLOWLOG RESET.
slowlog-max-len 128

################################ LATENCY MONITOR ##############################

# The Redis latency monitoring subsystem samples different operations
# at runtime in order to collect data related to possible sources of
# latency of a Redis instance.
#
# Via the LATENCY command this information is available to the user that can
# print graphs and obtain reports.
#
# The system only logs operations that were performed in a time equal or
# greater than the amount of milliseconds specified via the
# latency-monitor-threshold configuration directive. When its value is set
# to zero, the latency monitor is turned off.
#
# By default latency monitoring is disabled since it is mostly not needed
# if you don't have latency issues, and collecting data has a performance
# impact, that while very small, can be measured under big load. Latency
# monitoring can easily be enabled at runtime using the command
# "CONFIG SET latency-monitor-threshold <milliseconds>" if needed.
latency-monitor-threshold 0

############################# EVENT NOTIFICATION ##############################

# Redis can notify Pub/Sub clients about events happening in the key space.
# This feature is documented at http://redis.io/topics/notifications
#
# For instance if keyspace events notification is enabled, and a client
# performs a DEL operation on key "foo" stored in the Database 0, two
# messages will be published via Pub/Sub:
#
# PUBLISH __keyspace@0__:foo del
# PUBLISH __keyevent@0__:del foo
#
# It is possible to select the events that Redis will notify among a set
# of classes. Every class is identified by a single character:
#
#  K     Keyspace events, published with __keyspace@<db>__ prefix.
#  E     Keyevent events, published with __keyevent@<db>__ prefix.
#  g     Generic commands (non-type specific) like DEL, EXPIRE, RENAME, ...
#  $     String commands
#  l     List commands
#  s     Set commands
#  h     Hash commands
#  z     Sorted set commands
#  x     Expired events (events generated every time a key expires)
#  e     Evicted events (events generated when a key is evicted for maxmemory)
#  A     Alias for g$lshzxe, so that the "AKE" string means all the events.
#
#  The "notify-keyspace-events" takes as argument a string that is composed
#  of zero or multiple characters. The empty string means that notifications
#  are disabled.
#
#  Example: to enable list and generic events, from the point of view of the
#           event name, use:
#
#  notify-keyspace-events Elg
#
#  Example 2: to get the stream of the expired keys subscribing to channel
#             name __keyevent@0__:expired use:
#
#  notify-keyspace-events Ex
#
#  By default all notifications are disabled because most users don't need
#  this feature and the feature has some overhead. Note that if you don't
#  specify at least one of K or E, no events will be delivered.
notify-keyspace-events ""

############################### ADVANCED CONFIG ###############################

# Hashes are encoded using a memory efficient data structure when they have a
# small number of entries, and the biggest entry does not exceed a given
# threshold. These thresholds can be configured using the following directives.
hash-max-ziplist-entries 512
hash-max-ziplist-value 64

# Lists are also encoded in a special way to save a lot of space.
# The number of entries allowed per internal list node can be specified
# as a fixed maximum size or a maximum number of elements.
# For a fixed maximum size, use -5 through -1, meaning:
# -5: max size: 64 Kb  <-- not recommended for normal workloads
# -4: max size: 32 Kb  <-- not recommended
# -3: max size: 16 Kb  <-- probably not recommended
# -2: max size: 8 Kb   <-- good
# -1: max size: 4 Kb   <-- good
# Positive numbers mean store up to _exactly_ that number of elements
# per list node.
# The highest performing option is usually -2 (8 Kb size) or -1 (4 Kb size),
# but if your use case is unique, adjust the settings as necessary.
list-max-ziplist-size -2

# Lists may also be compressed.
# Compress depth is the number of quicklist ziplist nodes from *each* side of
# the list to *exclude* from compression.  The head and tail of the list
# are always uncompressed for fast push/pop operations.  Settings are:
# 0: disable all list compression
# 1: depth 1 means "don't start compressing until after 1 node into the list,
#    going from either the head or tail"
#    So: [head]->node->node->...->node->[tail]
#    [head], [tail] will always be uncompressed; inner nodes will compress.
# 2: [head]->[next]->node->node->...->node->[prev]->[tail]
#    2 here means: don't compress head or head->next or tail->prev or tail,
#    but compress all nodes between them.
# 3: [head]->[next]->[next]->node->node->...->node->[prev]->[prev]->[tail]
# etc.
list-compress-depth 0

# Sets have a special encoding in just one case: when a set is composed
# of just strings that happen to be integers in radix 10 in the range
# of 64 bit signed integers.
# The following configuration setting sets the limit in the size of the
# set in order to use this special memory saving encoding.
set-max-intset-entries 512

# Similarly to hashes and lists, sorted sets are also specially encoded in
# order to save a lot of space. This encoding is only used when the length and
# elements of a sorted set are below the following limits:
zset-max-ziplist-entries 128
zset-max-ziplist-value 64

# HyperLogLog sparse representation bytes limit. The limit includes the
# 16 bytes header. When an HyperLogLog using the sparse representation crosses
# this limit, it is converted into the dense representation.
#
# A value greater than 16000 is totally useless, since at that point the
# dense representation is more memory efficient.
#
# The suggested value is ~ 3000 in order to have the benefits of
# the space efficient encoding without slowing down too much PFADD,
# which is O(N) with the sparse encoding. The value can be raised to
# ~ 10000 when CPU is not a concern, but space is, and the data set is
# composed of many HyperLogLogs with cardinality in the 0 - 15000 range.
hll-sparse-max-bytes 3000

# Active rehashing uses 1 millisecond every 100 milliseconds of CPU time in
# order to help rehashing the main Redis hash table (the one mapping top-level
# keys to values). The hash table implementation Redis uses (see dict.c)
# performs a lazy rehashing: the more operation you run into a hash table
# that is rehashing, the more rehashing "steps" are performed, so if the
# server is idle the rehashing is never complete and some more memory is used
# by the hash table.
#
# The default is to use this millisecond 10 times every second in order to
# actively rehash the main dictionaries, freeing memory when possible.
#
# If unsure:
# use "activerehashing no" if you have hard latency requirements and it is
# not a good thing in your environment that Redis can reply from time to time
# to queries with 2 milliseconds delay.
#
# use "activerehashing yes" if you don't have such hard requirements but
# want to free memory asap when possible.
activerehashing yes

# The client output buffer limits can be used to force disconnection of clients
# that are not reading data from the server fast enough for some reason (a
# common reason is that a Pub/Sub client can't consume messages as fast as the
# publisher can produce them).
#
# The limit can be set differently for the three different classes of clients:
#
# normal -> normal clients including MONITOR clients
# slave  -> slave clients
# pubsub -> clients subscribed to at least one pubsub channel or pattern
#
# The syntax of every client-output-buffer-limit directive is the following:
#
# client-output-buffer-limit <class> <hard limit> <soft limit> <soft seconds>
#
# A client is immediately disconnected once the hard limit is reached, or if
# the soft limit is reached and remains reached for the specified number of
# seconds (continuously).
# So for instance if the hard limit is 32 megabytes and the soft limit is
# 16 megabytes / 10 seconds, the client will get disconnected immediately
# if the size of the output buffers reach 32 megabytes, but will also get
# disconnected if the client reaches 16 megabytes and continuously overcomes
# the limit for 10 seconds.
#
# By default normal clients are not limited because they don't receive data
# without asking (in a push way), but just after a request, so only
# asynchronous clients may create a scenario where data is requested faster
# than it can read.
#
# Instead there is a default limit for pubsub and slave clients, since
# subscribers and slaves receive data in a push fashion.
#
# Both the hard or the soft limit can be disabled by setting them to zero.
client-output-buffer-limit normal 0 0 0
client-output-buffer-limit slave 256mb 64mb 60
client-output-buffer-limit pubsub 32mb 8mb 60

# Redis calls an internal function to perform many background tasks, like
# closing connections of clients in timeout, purging expired keys that are
# never requested, and so forth.
#
# Not all tasks are performed with the same frequency, but Redis checks for
# tasks to perform according to the specified "hz" value.
#
# By default "hz" is set to 10. Raising the value will use more CPU when
# Redis is idle, but at the same time will make Redis more responsive when
# there are many keys expiring at the same time, and timeouts may be
# handled with more precision.
#
# The range is between 1 and 500, however a value over 100 is usually not
# a good idea. Most users should use the default of 10 and raise this up to
# 100 only in environments where very low latency is required.
hz 10

# When a child rewrites the AOF file, if the following option is enabled
# the file will be fsync-ed every 32 MB of data generated. This is useful
# in order to commit the file to the disk more incrementally and avoid
# big latency spikes.
aof-rewrite-incremental-fsync yes


```
