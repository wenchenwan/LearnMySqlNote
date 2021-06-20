# LearnMySqlNote
MySql的一点学习笔记

# MySQL学习笔记

## 1. 安装

（3、李玉婷2019版MySQL基础 https://www.bilibili.com/video/BV12b411K7Zu?p=253）

## 2.常用的命令

```mysql
net  start  MySQL服务名
net  stop  MySQL服务名

mysql -hlocalhost -P3306 -uroot -proot

show databases;

use mysql; 数据库
show tabes; 显示当前的数据表

show table from user; 直接显示user中的表

select database(); 查看当前的数据库

mysql> create table stuinfo(
    -> stuid int,
    -> stuname varchar(20),
    -> gender char,
    -> birthday datetime); 创建一个表
desc; 查看表的的结构

mysql> desc stuinfo;
+----------+-------------+------+-----+---------+-------+
| Field    | Type        | Null | Key | Default | Extra |
+----------+-------------+------+-----+---------+-------+
| stuid    | int(11)     | YES  |     | NULL    |       |
| stuname  | varchar(20) | YES  |     | NULL    |       |
| gender   | char(1)     | YES  |     | NULL    |       |
| birthday | datetime    | YES  |     | NULL    |       |
+----------+-------------+------+-----+---------+-------+
4 rows in set (0.01 sec)

select * from stuinfo; 
#查看表的数据
insert into stuinfo values(1,"Mr zhang","男","1990-01-02"); 
#插入数据

#PS:如果出现中文名报错的情况，需要设置一下name的编码格式
mysql> insert into stuinfo values(1,"刘三元","男","1980-01-02");
ERROR 1366 (HY000): Incorrect string value: '\xC1\xF5\xC8\xFD\xD4\xAA' for column 'stuname' at row 1

set names gbk;

#更改表的信息
update stuinfo set birthday="1990-01-04" where stuname="刘三元";

#删除表的信息
delete from stuinfo where stuname = "刘三元";

#修改表的结构
alter table stuinfo add column email varchar(20);

#删除表
drop table stuinfo

#退出
exit
```

sql不区分大小写

```sql
注释
#
--(空格) 
/* */多行注释
```

### 2.1 基础查询

```mysql
#进阶一：基础查询
/*
语法select 查询列表 from 表名

特点：
1.查询的结果集，是一个虚拟表
2.select查询表 类似于system.out.printin(打印内容)

select后面跟的查询列表，可以由多个部分组成，中间用逗号隔开
例如：select字段1，字段2，表达式 from 表；

system.out.println()的打印内容，只能有一个

3.执行顺序

select first_name from employees;
①from employees
②select first_name

4.查询的列表可以是：字段、表达式、常量、函数等

*/

#一、查询常量
SELECT 100;

#二、查询表达式
SELECT 100%3;

#三、查询单个字段
SELECT last_name FROM employees;

#四、查询多个字段
SELECT `first_name`, `last_name`, `email` FROM employees;

#五、查询所有字段
SELECT * FROM employees;

#F12可以快捷对齐
SELECT 
  `first_name`,
  `last_name`,
  `email`,
  `phone_number`,
  `job_id` 
FROM
  employees ;

#六、查询函数（调用函数，获得返回值）
SELECT DATABASE();
#查询当前的数据库

SELECT VERSION();
#查看当前数据库版本

SELECT USER();
#查看当前的用户

#七、起别名
#方式一：使用as关键字

SELECT USER() AS 用户名;
SELECT USER() AS '用户名';
SELECT USER() AS "用户名";

SELECT last_name FROM employees;
SELECT last_name AS 姓名 FROM employees;
SELECT last_name AS '姓名' FROM employees;

#方式二：使用空格
SELECT last_name 姓名 FROM employees;
SELECT last_name '姓名' FROM employees;

#八、
#需求：查询first_name和last_name拼接成的全名，最终起名为姓名
#方案一 +
SELECT first_name+last_name AS 姓名 FROM employees;
#
# 加号+
# 1.加法运算
# ①两个操作数都是数值型
# 100 + 10.1

# ②其中一个是操作数
# ”张无极“ + 10
# 将字符串转换为数值类型，如果无法转换就直接变为0

# ③其中一个操作数是null
# null + 100 -> null
# null + null -> null
#
#方案二 concat
SELECT CONCAT(first_name," ",last_name) AS 姓名 FROM employees;


#九、distinct的使用
#查询员工涉及到的部分编号有那些
SELECT DISTINCT department_id FROM employees;

#十、查看表的结构
DESC employees; 
SHOW COLUMNS FROM employees;

#ifnull(表达式1，表达式2)
#表达式1为可能为null的值，表达式2为当表达式1为null最终的显示值
#


SELECT 
  CONCAT(
    `employee_id`,
    ',',
    `first_name`,
    ',',
    `last_name`,
    ',',
    `email`,
    ',',
    IFNULL(`commission_pct`, 'null')
  ) AS put 
FROM
  employees ;

  
SELECT `commission_pct`,IFNULL(`commission_pct`,"空") FROM employees;
```

### 2.2 条件查询

```mysql
#进阶二：条件查询
/*
语法：
select 查询列表
from 表
where 筛选条件;

执行顺序
① from子句
② where 子句
③ select 子句

select last_name,first_name from employees where salary > 2000;

特点：
1、按关系表达式筛选
关系运算符 > < >= <= = != <>
	不建议使用!=
	
2、按逻辑运算筛选
逻辑运算符
AND OR NOT
&&  ||  !

3、模糊查询
like
between and
is null

*/

SELECT last_name,first_name FROM employees WHERE salary > 2000;
#一、按关系表达式筛选
#案例1、查询部门编号不是100的员工信息
SELECT 
  * 
FROM
  employees 
WHERE department_id != 100 ;

#案例二、查询工资小于15000的姓名和工资


SELECT 
  CONCAT(last_name, " ", first_name) AS "姓名",
  salary 
FROM
  employees 
WHERE salary < 15000 ;

#二、按逻辑表达式查询
#案例1：查询部门编号不是50 -100 之间的员工姓名、部门编号、邮箱

#方式1
SELECT 
  CONCAT(last_name, " ", first_name) AS "姓名",
  department_id,
  email 
FROM
  employees 
WHERE department_id < 50 
  OR department_id > 100 ;
  
#方式2
SELECT 
  CONCAT(last_name, " ", first_name) AS "姓名",
  department_id,
  email 
FROM
  employees 
WHERE !(department_id > 50 
  AND department_id < 100) ;

#案例2、查询奖金率 > 0.03或者 员工编号在60-100之间的员工信息
SELECT 
  * 
FROM
  employees 
WHERE (
    commission_pct > 0.03 
    AND employee_id > 110
  ) ;

```

### 2.3 模糊查询

```mysql
#三、模糊查询
/*
一般和通配符搭配使用，对字符数据进行部分匹配查询
常见的通配字符
_ 任意单个字符
% 任意多个字符

也可以使用not like
*/
#案例一、 查询姓名中包含字符a的员工信息
SELECT 
  * 
FROM
  employees 
WHERE last_name LIKE '%a%' ;
#案例二、姓名中最后一个字符为e的员工信息
SELECT 
  * 
FROM
  employees 
WHERE last_name LIKE '%e' ;

#案例三、姓名第一个字符为m的员工信息
SELECT 
  * 
FROM
  employees 
WHERE last_name LIKE 'm%' ;

#案例四、姓名中包含三个字母为x的员工信息
SELECT 
  * 
FROM
  employees 
WHERE last_name LIKE '__x%' ;

#案例四、姓名第二字符为_的员工信息
SELECT 
  * 
FROM
  employees 
WHERE last_name LIKE '_\_%' ;

#或者
SELECT 
  * 
FROM
  employees 
WHERE last_name LIKE '_&_%' ESCAPE '&';

#2、in
/*
功能：查询某字段的值是否属于指定的列表范围内
in(常量值1，常量值2，常量值3，...)
或者 not in(常量值1，常量值2，常量值3，...)
*/
#案例1：查询部门编号是30，50，90的员工信息
SELECT 
  last_name,
  department_id 
FROM
  employees 
WHERE department_id IN (30, 50, 90) ;
# not in
SELECT 
  last_name,
  department_id 
FROM
  employees 
WHERE department_id NOT IN (30, 50, 90) ;


#只是简洁性不一样
SELECT 
  last_name,
  department_id 
FROM
  employees 
WHERE department_id = 30 
  OR department_id = 50 
  OR department_id = 90;
   
#案例二、查询工种编号不是SH_CLERK或者IT_PROG的员工信息
SELECT 
  * 
FROM
  employees 
WHERE job_id IN ("SH_CLERK", "IT_PROG") ;

#3、between and
/*
功能：判断某个字段的值是否介于什么之间
between and / not between and
*/
#案例1、查询部门编号是30-90之间的部门编号
SELECT 
  department_id,
  last_name 
FROM
  employees 
WHERE department_id BETWEEN 30 
  AND 90 ;
#30和90不可以颠倒

#案例2、查询年薪不是100000-200000之间的员工、工资、年薪
SELECT 
  last_name,
  salary,
  salary * 12 * (1 + IFNULL(commission_pct, 0)) AS annual 
FROM
  employees 
WHERE NOT (salary * 12 * (1 + IFNULL(commission_pct, 0)) > 100000 OR salary * 12 * (1 + IFNULL(commission_pct, 0)) < 20000);


#
SELECT 
  last_name,
  salary,
  salary * 12 * (1 + IFNULL(commission_pct, 0)) AS annual 
FROM
  employees 
WHERE salary * 12 * (1 + IFNULL(commission_pct, 0)) NOT BETWEEN 100000 AND 20000;

#4、is null/is not null
#案例1：查询奖金率为空的员工信息
SELECT 
  * 
FROM
  employees 
WHERE commission_pct IS NULL ;

SELECT 
  * 
FROM
  employees 
WHERE commission_pct IS NOT NULL ;


SELECT 
  * 
FROM
  employees 
WHERE salary IS 10000 ;
#<-------------->
#
# = 	只能判断普通内容
# IS	只能用来判断null值
#<=> 	安全等于，既能判断普通内容，也能判断null值
#
```

### 2.4 排序查询

```mysql
#进阶3、排序查询
/*
语法：
语法：
select 查询列表
from 表
{where 筛选条件}
order by 排序列表;

执行顺序
① from子句
② where 子句
③ select 子句
④ order by 子句

举例：
select last_name, salary
from employees
where salary > 10000
order by salary;

特点：
1、排序列表可以是单个字段、多个字段、表达式、函数、列数、以及以上的组合
2、升序	asc
   降序	desc
*/
#一、按单个字段排序
#案例1：将员工编号大于120的员工信息，按工资进行升序
SELECT 
  * 
FROM
  employees 
WHERE employee_id > 120 
ORDER BY salary ASC ;

#案例2：将员工编号大于120的员工信息，按工资进行降序

SELECT 
  * 
FROM
  employees 
WHERE employee_id > 120 
ORDER BY salary DESC ;

#二、按表达式排序
#案例1:对有奖金的员工，按年薪降序

SELECT * ,salary*12*(1+IFNULL(`commission_pct`,0)) 
FROM employees
WHERE commission_pct IS NOT NULL
ORDER BY salary*12*(1+IFNULL(`commission_pct`,0)) DESC


SELECT * ,salary*12*(1+IFNULL(`commission_pct`,0))  年薪
FROM employees

ORDER BY 年薪 DESC

#四、按函数结果查询排序

#案例1：按姓名长度进行排序
SELECT LENGTH(last_name),last_name
FROM employees
ORDER BY LENGTH(last_name);


#五、按多个字段排序
#案例1：查询员工的姓名、工资、部门编号，先按工资升序，再按部门编号降序

SELECT 
  last_name,
  salary,
  department_id 
FROM
  employees 
ORDER BY salary ASC,
  department_id DESC ;

#六、按列数排序

SELECT 
  * 
FROM
  employees 
ORDER BY 2 ;

SELECT 
  * 
FROM
  employees 
ORDER BY first_name DESC;
```

## 3. 常见函数

```mysql
/*
函数：类似于java中学过的“方法”，
为了解决某个问题，将编写的一系列的命令集合封装在一起，对外仅仅暴露方法名，供外部调用

1、自定义方法(函数)
2、调用方法(函数)★
	叫什么  ：函数名
	干什么  ：函数功能
	

常见函数：
单行函数
	字符函数
		concat
		substr
		length（str）
		char_length
		upper
		lower
		trim
		left
		right
		lpad
		rpad
		instr
		strcmp
	数学函数
		abs
		ceil
		floor
		round
		truncate
		mod
		
	日期函数
		now 
		curtime
		curdate
		datediff
		date_format
		str_to_date
		
	流程控制函数
		if
		case
*/
#一、字符函数
1、CONCAT 拼接字符

SELECT CONCAT('hello,',first_name,last_name)  备注 FROM employees;

2、LENGTH 获取字节长度

SELECT LENGTH('hello,郭襄');

3、CHAR_LENGTH 获取字符个数
SELECT CHAR_LENGTH('hello,郭襄');

4、SUBSTRING 截取子串
/*
注意：起始索引从1开始！！！
substr(str,起始索引，截取的字符长度)
substr(str,起始索引)
*/
SELECT SUBSTR('张三丰爱上了郭襄',1,3);
SELECT SUBSTR('张三丰爱上了郭襄',7);

5、INSTR获取字符第一次出现的索引

SELECT INSTR('三打白骨精aaa白骨精bb白骨精','白骨精');

6、TRIM去前后指定的字符，默认是去空格


SELECT TRIM(' 虚  竹    ')  AS a;
SELECT TRIM('x' FROM 'xxxxxx虚xxx竹xxxxxxxxxxxxxxxxxx')  AS a;

7、LPAD/RPAD  左填充/右填充
SELECT LPAD('木婉清',10,'a');
SELECT RPAD('木婉清',10,'a');

8、UPPER/LOWER  变大写/变小写

#案例：查询员工表的姓名，要求格式：姓首字符大写，其他字符小写，名所有字符大写，且姓和名之间用_分割，最后起别名“OUTPUT”


SELECT UPPER(SUBSTR(first_name,1,1)),first_name FROM employees;
SELECT LOWER(SUBSTR(first_name,2)),first_name FROM employees;
SELECT UPPER(last_name) FROM employees;

SELECT CONCAT(UPPER(SUBSTR(first_name,1,1)),LOWER(SUBSTR(first_name,2)),'_',UPPER(last_name)) "OUTPUT"
FROM employees;

9、STRCMP 比较两个字符大小

SELECT STRCMP('aec','aec');


10、LEFT/RIGHT  截取子串
SELECT LEFT('鸠摩智',1);
SELECT RIGHT('鸠摩智',1);

#二、数学函数

1、ABS 绝对值
SELECT ABS(-2.4);
2、CEIL 向上取整  返回>=该参数的最小整数
SELECT CEIL(-1.09);
SELECT CEIL(0.09);
SELECT CEIL(1.00);

3、FLOOR 向下取整，返回<=该参数的最大整数
SELECT FLOOR(-1.09);
SELECT FLOOR(0.09);
SELECT FLOOR(1.00);

4、ROUND 四舍五入
SELECT ROUND(1.8712345);
SELECT ROUND(1.8712345,2);

5、TRUNCATE 截断

SELECT TRUNCATE(1.8712345,1);

6、MOD 取余

SELECT MOD(-10,3);
a%b = a-(INT)a/b*b
-10%3 = -10 - (-10)/3*3   = -1

SELECT -10%3;
SELECT 10%3;
SELECT -10%-3;
SELECT 10%-3;


#三、日期函数


1、NOW
SELECT NOW();

2、CURDATE

SELECT CURDATE();

3、CURTIME
SELECT CURTIME();


4、DATEDIFF
SELECT DATEDIFF('1998-7-16','2019-7-13');

5、DATE_FORMAT

SELECT DATE_FORMAT('1998-7-16','%Y年%m月%d日 %H小时%i分钟%s秒') 出生日期;



SELECT 
  DATE_FORMAT(
    hiredate,
    '%Y年%m月%d日 %H小时%i分钟%s秒'
  ) 入职日期 
FROM
  employees ;



6 、 STR_TO_DATE按指定格式解析字符串为日期类型 
SELECT 
  * 
FROM
  employees 
WHERE hiredate < STR_TO_DATE('3/15 1998', '%m/%d %Y') ;



#四、流程控制函数


1、IF函数

SELECT IF(100>9,'好','坏');


#需求：如果有奖金，则显示最终奖金，如果没有，则显示0
SELECT IF(commission_pct IS NULL,0,salary*12*commission_pct)  奖金,commission_pct
FROM employees;



2、CASE函数

①情况1 ：类似于switch语句，可以实现等值判断
CASE 表达式
WHEN 值1 THEN 结果1
WHEN 值2 THEN 结果2
...
ELSE 结果n
END


案例：
部门编号是30，工资显示为2倍
部门编号是50，工资显示为3倍
部门编号是60，工资显示为4倍
否则不变

显示 部门编号，新工资，旧工资

SELECT department_id,salary,
CASE department_id
WHEN 30 THEN salary*2
WHEN 50 THEN salary*3
WHEN 60 THEN salary*4
ELSE salary
END  newSalary
FROM employees;


②情况2：类似于多重IF语句，实现区间判断
CASE 
WHEN 条件1 THEN 结果1
WHEN 条件2 THEN 结果2
...

ELSE 结果n

END



案例：如果工资>20000,显示级别A
      工资>15000,显示级别B
      工资>10000,显示级别C
      否则，显示D
      
 SELECT salary,
 CASE 
 WHEN salary>20000 THEN 'A'
 WHEN salary>15000 THEN 'B'
 WHEN salary>10000 THEN 'C'
 ELSE 'D'
 END
 AS  a
 FROM employees;   

```

**分组函数**

```mysql
#进阶5：分组函数
/*

说明：分组函数往往用于实现将一组数据进行统计计算，最终得到一个值，又称为聚合函数或统计函数

分组函数清单：

sum(字段名)：求和
avg(字段名)：求平均数
max(字段名)：求最大值
min(字段名)：求最小值
count(字段名)：计算非空字段值的个数

*/

#案例1 ：查询员工信息表中，所有员工的工资和、工资平均值、最低工资、最高工资、有工资的个数

SELECT SUM(salary),AVG(salary),MIN(salary),MAX(salary),COUNT(salary) FROM employees;

#案例2：添加筛选条件
	#①查询emp表中记录数：
	SELECT COUNT(employee_id) FROM employees;

	#②查询emp表中有佣金的人数：
	
	SELECT COUNT(salary) FROM employees;
	
	
	#③查询emp表中月薪大于2500的人数：
	SELECT COUNT(salary) FROM employees WHERE salary>2500;

	
	#④查询有领导的人数：
	SELECT COUNT(manager_id) FROM employees;
	
	
#count的补充介绍★


#1、统计结果集的行数，推荐使用count(*)
	
SELECT COUNT(*) FROM employees;
SELECT COUNT(*) FROM employees WHERE department_id = 30;


SELECT COUNT(1) FROM employees;
SELECT COUNT(1) FROM employees WHERE department_id = 30;


#2、搭配distinct实现去重的统计

#需求：查询有员工的部门个数

SELECT COUNT(DISTINCT department_id) FROM employees;


#思考：每个部门的总工资、平均工资？

SELECT SUM(salary)  FROM employees WHERE department_id = 30;
SELECT SUM(salary)  FROM employees WHERE department_id = 50;


SELECT SUM(salary) ,department_id
FROM employees
GROUP BY department_id;

```

**连接函数**

```mysql
#进阶6：连接查询
/*
说明：又称多表查询，当查询语句涉及到的字段来自于多个表时，就会用到连接查询

笛卡尔乘积现象：表1 有m行，表2有n行，结果=m*n行

	发生原因：没有有效的连接条件
	如何避免：添加有效的连接条件

分类：

	按年代分类：
	1、sql92标准:仅仅支持内连接
		内连接：
			等值连接
			非等值连接
			自连接
	2、sql99标准【推荐】：支持内连接+外连接（左外和右外）+交叉连接
	
	按功能分类：
		内连接：
			等值连接
			非等值连接
			自连接
		外连接：
			左外连接
			右外连接
			全外连接
		
		交叉连接


*/
#引入案例
#查询女神名和对应的男神名
SELECT * FROM beauty;

SELECT * FROM boys;


SELECT NAME,boyName FROM boys,beauty
WHERE beauty.boyfriend_id= boys.id;

#---------------------------------sql92标准------------------
#一、内连接
/*
语法:
select 查询列表
from 表1 别名,表2 别名
where 连接条件
and 筛选条件
group by 分组列表
having 分组后筛选
order by 排序列表

执行顺序：

1、from子句
2、where子句
3、and子句
4、group by子句
5、having子句
6、select子句
7、order by子句

*/


#一）等值连接
/*

① 多表等值连接的结果为多表的交集部分
②n表连接，至少需要n-1个连接条件
③ 多表的顺序没有要求
④一般需要为表起别名
⑤可以搭配前面介绍的所有子句使用，比如排序、分组、筛选


*/



#案例1：查询女神名和对应的男神名
SELECT NAME,boyName 
FROM boys,beauty
WHERE beauty.boyfriend_id= boys.id;

#案例2：查询员工名和对应的部门名

SELECT last_name,department_name
FROM employees,departments
WHERE employees.`department_id`=departments.`department_id`;



#2、为表起别名
/*
①提高语句的简洁度
②区分多个重名的字段

注意：如果为表起了别名，则查询的字段就不能使用原来的表名去限定

*/
#查询员工名、工种号、工种名

SELECT e.last_name,e.job_id,j.job_title
FROM employees  e,jobs j
WHERE e.`job_id`=j.`job_id`;


#3、两个表的顺序是否可以调换

#查询员工名、工种号、工种名

SELECT e.last_name,e.job_id,j.job_title
FROM jobs j,employees e
WHERE e.`job_id`=j.`job_id`;


#4、可以加筛选


#案例：查询有奖金的员工名、部门名

SELECT last_name,department_name,commission_pct

FROM employees e,departments d
WHERE e.`department_id`=d.`department_id`
AND e.`commission_pct` IS NOT NULL;

#案例2：查询城市名中第二个字符为o的部门名和城市名

SELECT department_name,city
FROM departments d,locations l
WHERE d.`location_id` = l.`location_id`
AND city LIKE '_o%';

#5、可以加分组


#案例1：查询每个城市的部门个数

SELECT COUNT(*) 个数,city
FROM departments d,locations l
WHERE d.`location_id`=l.`location_id`
GROUP BY city;


#案例2：查询有奖金的每个部门的部门名和部门的领导编号和该部门的最低工资
SELECT department_name,d.`manager_id`,MIN(salary)
FROM departments d,employees e
WHERE d.`department_id`=e.`department_id`
AND commission_pct IS NOT NULL
GROUP BY department_name,d.`manager_id`;
#6、可以加排序


#案例：查询每个工种的工种名和员工的个数，并且按员工个数降序

SELECT job_title,COUNT(*)
FROM employees e,jobs j
WHERE e.`job_id`=j.`job_id`
GROUP BY job_title
ORDER BY COUNT(*) DESC;




#7、可以实现三表连接？

#案例：查询员工名、部门名和所在的城市

SELECT last_name,department_name,city
FROM employees e,departments d,locations l
WHERE e.`department_id`=d.`department_id`
AND d.`location_id`=l.`location_id`
AND city LIKE 's%'

ORDER BY department_name DESC;



#二）非等值连接


#案例1：查询员工的工资和工资级别


SELECT salary,grade_level
FROM employees e,job_grades g
WHERE salary BETWEEN g.`lowest_sal` AND g.`highest_sal`
AND g.`grade_level`='A';

/*
select salary,employee_id from employees;
select * from job_grades;
CREATE TABLE job_grades
(grade_level VARCHAR(3),
 lowest_sal  int,
 highest_sal int);

INSERT INTO job_grades
VALUES ('A', 1000, 2999);

INSERT INTO job_grades
VALUES ('B', 3000, 5999);

INSERT INTO job_grades
VALUES('C', 6000, 9999);

INSERT INTO job_grades
VALUES('D', 10000, 14999);

INSERT INTO job_grades
VALUES('E', 15000, 24999);

INSERT INTO job_grades
VALUES('F', 25000, 40000);

*/




#三）自连接



#案例：查询 员工名和上级的名称

SELECT e.employee_id,e.last_name,m.employee_id,m.last_name
FROM employees e,employees m
WHERE e.`manager_id`=m.`employee_id`;



#------------------------SQL99语法
#一、内连接
语法：

SELECT 查询列表
FROM 表名1 别名
【INNER】 JOIN  表名2 别名
ON 连接条件
WHERE 筛选条件
GROUP BY 分组列表
HAVING 分组后筛选
ORDER BY 排序列表;


SQL92和SQL99的区别：

	SQL99，使用JOIN关键字代替了之前的逗号，并且将连接条件和筛选条件进行了分离，提高阅读性！！！



#一）等值连接
#①简单连接
#案例：查询员工名和部门名

SELECT last_name,department_name
FROM departments d 
 JOIN  employees e 
ON e.department_id =d.department_id;



#②添加筛选条件
#案例1：查询部门编号>100的部门名和所在的城市名
SELECT department_name,city
FROM departments d
JOIN locations l
ON d.`location_id` = l.`location_id`
WHERE d.`department_id`>100;


#③添加分组+筛选
#案例1：查询每个城市的部门个数

SELECT COUNT(*) 部门个数,l.`city`
FROM departments d
JOIN locations l
ON d.`location_id`=l.`location_id`
GROUP BY l.`city`;




#④添加分组+筛选+排序
#案例1：查询部门中员工个数>10的部门名，并按员工个数降序

SELECT COUNT(*) 员工个数,d.department_name
FROM employees e
JOIN departments d
ON e.`department_id`=d.`department_id`
GROUP BY d.`department_id`
HAVING 员工个数>10
ORDER BY 员工个数 DESC;







#二）非等值连接

#案例：查询部门编号在10-90之间的员工的工资级别，并按级别进行分组
SELECT * FROM sal_grade;


SELECT COUNT(*) 个数,grade
FROM employees e
JOIN sal_grade g
ON e.`salary` BETWEEN g.`min_salary` AND g.`max_salary`
WHERE e.`department_id` BETWEEN 10 AND 90
GROUP BY g.grade;




#三）自连接

#案例：查询员工名和对应的领导名

SELECT e.`last_name`,m.`last_name`
FROM employees e
JOIN employees m
ON e.`manager_id`=m.`employee_id`;



#二、外连接

/*

说明：查询结果为主表中所有的记录，如果从表有匹配项，则显示匹配项；如果从表没有匹配项，则显示null

应用场景：一般用于查询主表中有但从表没有的记录

特点：

1、外连接分主从表，两表的顺序不能任意调换
2、左连接的话，left join左边为主表
   右连接的话，right join右边为主表
   

语法：

select 查询列表
from 表1 别名
left|right|full 【outer】 join 表2 别名
on 连接条件
where 筛选条件;

*/
USE girls;
#案例1：查询所有女神记录，以及对应的男神名，如果没有对应的男神，则显示为null

#左连接
SELECT b.*,bo.*
FROM beauty b
LEFT JOIN boys bo ON b.`boyfriend_id` = bo.`id`;

#右连接
SELECT b.*,bo.*
FROM boys bo
RIGHT JOIN  beauty b ON b.`boyfriend_id` = bo.`id`;







#案例2：查哪个女神没有男朋友

#左连接
SELECT b.`name`
FROM beauty b
LEFT JOIN boys bo ON b.`boyfriend_id` = bo.`id`
WHERE bo.`id`  IS NULL;

#右连接
SELECT b.*,bo.*
FROM boys bo
RIGHT JOIN  beauty b ON b.`boyfriend_id` = bo.`id`
WHERE bo.`id`  IS NULL;


#案例3：查询哪个部门没有员工，并显示其部门编号和部门名

SELECT COUNT(*) 部门个数
FROM departments d
LEFT JOIN employees e ON d.`department_id` = e.`department_id`
WHERE e.`employee_id` IS NULL;
```

**分组查询**

```mysql
#进阶6：分组查询
/*
语法：

select 查询列表
from 表名
where 筛选条件
group by 分组列表
having 分组后筛选
order by 排序列表;

执行顺序：
①from子句
②where子句
③group by 子句
④having子句
⑤select子句
⑥order by子句






特点：
①查询列表往往是  分组函数和被分组的字段 ★
②分组查询中的筛选分为两类
			筛选的基表	使用的关键词		位置
分组前筛选		原始表		where			group by 的前面

分组后筛选		分组后的结果集  having			group by的后面

where——group by ——having

问题：分组函数做条件只可能放在having后面！！！

*/


#1）简单的分组
#案例1：查询每个工种的员工平均工资

SELECT AVG(salary),job_id
FROM employees
GROUP BY job_id;

#案例2：查询每个领导的手下人数

SELECT COUNT(*),manager_id
FROM employees
WHERE manager_id IS NOT NULL
GROUP BY manager_id;





#2）可以实现分组前的筛选
#案例1：查询邮箱中包含a字符的 每个部门的最高工资
SELECT MAX(salary) 最高工资,department_id
FROM employees
WHERE email LIKE '%a%'
GROUP BY department_id;


#案例2：查询每个领导手下有奖金的员工的平均工资
SELECT AVG(salary) 平均工资,manager_id
FROM employees
WHERE commission_pct IS NOT NULL
GROUP BY manager_id;


#3）可以实现分组后的筛选
#案例1：查询哪个部门的员工个数>5
#分析1：查询每个部门的员工个数
SELECT COUNT(*) 员工个数,department_id
FROM employees
GROUP BY department_id

#分析2：在刚才的结果基础上，筛选哪个部门的员工个数>5

SELECT COUNT(*) 员工个数,department_id
FROM employees

GROUP BY department_id
HAVING  COUNT(*)>5;


#案例2：每个工种有奖金的员工的最高工资>12000的工种编号和最高工资

SELECT job_id,MAX(salary)
FROM employees
WHERE commission_pct  IS NOT NULL
GROUP BY job_id
HAVING MAX(salary)>12000;


#案例3：领导编号>102的    每个领导手下的最低工资大于5000的最低工资
#分析1：查询每个领导手下员工的最低工资
SELECT MIN(salary) 最低工资,manager_id
FROM employees
GROUP BY manager_id;

#分析2：筛选刚才1的结果
SELECT MIN(salary) 最低工资,manager_id
FROM employees
WHERE manager_id>102
GROUP BY manager_id
HAVING MIN(salary)>5000 ;




#4）可以实现排序
#案例：查询没有奖金的员工的最高工资>6000的工种编号和最高工资,按最高工资升序
#分析1：按工种分组，查询每个工种有奖金的员工的最高工资
SELECT MAX(salary) 最高工资,job_id
FROM employees
WHERE commission_pct IS  NULL
GROUP BY job_id


#分析2：筛选刚才的结果，看哪个最高工资>6000
SELECT MAX(salary) 最高工资,job_id
FROM employees
WHERE commission_pct IS  NULL
GROUP BY job_id
HAVING MAX(salary)>6000


#分析3：按最高工资升序
SELECT MAX(salary) 最高工资,job_id
FROM employees
WHERE commission_pct IS  NULL
GROUP BY job_id
HAVING MAX(salary)>6000
ORDER BY MAX(salary) ASC;


#5）按多个字段分组
#案例：查询每个工种每个部门的最低工资,并按最低工资降序
#提示：工种和部门都一样，才是一组

工种	部门  工资
1	10	10000
1       20      2000
2	20
3       20
1       10
2       30
2       20


SELECT MIN(salary) 最低工资,job_id,department_id
FROM employees
GROUP BY job_id,department_id;

```

**连接查询**

```mysql
#进阶6：连接查询
/*
说明：又称多表查询，当查询语句涉及到的字段来自于多个表时，就会用到连接查询

笛卡尔乘积现象：表1 有m行，表2有n行，结果=m*n行

	发生原因：没有有效的连接条件
	如何避免：添加有效的连接条件

分类：

	按年代分类：
	1、sql92标准:仅仅支持内连接
		内连接：
			等值连接
			非等值连接
			自连接
	2、sql99标准【推荐】：支持内连接+外连接（左外和右外）+交叉连接
	
	按功能分类：
		内连接：
			等值连接
			非等值连接
			自连接
		外连接：
			左外连接
			右外连接
			全外连接
		
		交叉连接


*/
#引入案例
#查询女神名和对应的男神名
SELECT * FROM beauty;

SELECT * FROM boys;


SELECT NAME,boyName FROM boys,beauty
WHERE beauty.boyfriend_id= boys.id;

#---------------------------------sql92标准------------------
#一、内连接
/*
语法:
select 查询列表
from 表1 别名,表2 别名
where 连接条件
and 筛选条件
group by 分组列表
having 分组后筛选
order by 排序列表

执行顺序：

1、from子句
2、where子句
3、and子句
4、group by子句
5、having子句
6、select子句
7、order by子句




*/


#一）等值连接
/*

① 多表等值连接的结果为多表的交集部分
②n表连接，至少需要n-1个连接条件
③ 多表的顺序没有要求
④一般需要为表起别名
⑤可以搭配前面介绍的所有子句使用，比如排序、分组、筛选


*/



#案例1：查询女神名和对应的男神名
SELECT NAME,boyName 
FROM boys,beauty
WHERE beauty.boyfriend_id= boys.id;

#案例2：查询员工名和对应的部门名

SELECT last_name,department_name
FROM employees,departments
WHERE employees.`department_id`=departments.`department_id`;

USE myemployees;
SELECT e.last_name,d.department_name
FROM employees e,departments d
WHERE e.`department_id`=d.`department_id`;


#2、为表起别名
/*
①提高语句的简洁度
②区分多个重名的字段

注意：如果为表起了别名，则查询的字段就不能使用原来的表名去限定

*/
#查询员工名、工种号、工种名

SELECT e.last_name,e.job_id,j.job_title
FROM employees  e,jobs j
WHERE e.`job_id`=j.`job_id`;


#3、两个表的顺序是否可以调换

#查询员工名、工种号、工种名

SELECT e.last_name,e.job_id,j.job_title
FROM jobs j,employees e
WHERE e.`job_id`=j.`job_id`;


#4、可以加筛选


#案例：查询有奖金的员工名、部门名

SELECT last_name,department_name,commission_pct

FROM employees e,departments d
WHERE e.`department_id`=d.`department_id`
AND e.`commission_pct` IS NOT NULL;

#案例2：查询城市名中第二个字符为o的部门名和城市名

SELECT department_name,city
FROM departments d,locations l
WHERE d.`location_id` = l.`location_id`
AND city LIKE '_o%';

#5、可以加分组


#案例1：查询每个城市的部门个数

SELECT COUNT(*) 个数,city
FROM departments d,locations l
WHERE d.`location_id`=l.`location_id`
GROUP BY city;


#案例2：查询有奖金的每个部门的部门名和部门的领导编号和该部门的最低工资
SELECT department_name,d.`manager_id`,MIN(salary)
FROM departments d,employees e
WHERE d.`department_id`=e.`department_id`
AND commission_pct IS NOT NULL
GROUP BY department_name,d.`manager_id`;
#6、可以加排序


#案例：查询每个工种的工种名和员工的个数，并且按员工个数降序

SELECT job_title,COUNT(*)
FROM employees e,jobs j
WHERE e.`job_id`=j.`job_id`
GROUP BY job_title
ORDER BY COUNT(*) DESC;




#7、可以实现三表连接？

#案例：查询员工名、部门名和所在的城市

SELECT last_name,department_name,city
FROM employees e,departments d,locations l
WHERE e.`department_id`=d.`department_id`
AND d.`location_id`=l.`location_id`
AND city LIKE 's%'

ORDER BY department_name DESC;



#二）非等值连接


#案例1：查询员工的工资和工资级别


SELECT salary,grade_level
FROM employees e,job_grades g
WHERE salary BETWEEN g.`lowest_sal` AND g.`highest_sal`
AND g.`grade_level`='A';

/*
select salary,employee_id from employees;
select * from job_grades;
CREATE TABLE job_grades
(grade_level VARCHAR(3),
 lowest_sal  int,
 highest_sal int);

INSERT INTO job_grades
VALUES ('A', 1000, 2999);

INSERT INTO job_grades
VALUES ('B', 3000, 5999);

INSERT INTO job_grades
VALUES('C', 6000, 9999);

INSERT INTO job_grades
VALUES('D', 10000, 14999);

INSERT INTO job_grades
VALUES('E', 15000, 24999);

INSERT INTO job_grades
VALUES('F', 25000, 40000);

*/




#三）自连接



#案例：查询 员工名和上级的名称

SELECT e.employee_id,e.last_name,m.employee_id,m.last_name
FROM employees e,employees m
WHERE e.`manager_id`=m.`employee_id`;



#------------------------SQL99语法
#一、内连接
语法：

SELECT 查询列表
FROM 表名1 别名
【INNER】 JOIN  表名2 别名
ON 连接条件
WHERE 筛选条件
GROUP BY 分组列表
HAVING 分组后筛选
ORDER BY 排序列表;


SQL92和SQL99的区别：

	SQL99，使用JOIN关键字代替了之前的逗号，并且将连接条件和筛选条件进行了分离，提高阅读性！！！



#一）等值连接
#①简单连接
#案例：查询员工名和部门名

SELECT last_name,department_name
FROM departments d 
 JOIN  employees e 
ON e.department_id =d.department_id;



#②添加筛选条件
#案例1：查询部门编号>100的部门名和所在的城市名
SELECT department_name,city
FROM departments d
JOIN locations l
ON d.`location_id` = l.`location_id`
WHERE d.`department_id`>100;


#③添加分组+筛选
#案例1：查询每个城市的部门个数

SELECT COUNT(*) 部门个数,l.`city`
FROM departments d
JOIN locations l
ON d.`location_id`=l.`location_id`
GROUP BY l.`city`;




#④添加分组+筛选+排序
#案例1：查询部门中员工个数>10的部门名，并按员工个数降序

SELECT COUNT(*) 员工个数,d.department_name
FROM employees e
JOIN departments d
ON e.`department_id`=d.`department_id`
GROUP BY d.`department_id`
HAVING 员工个数>10
ORDER BY 员工个数 DESC;







#二）非等值连接

#案例：查询部门编号在10-90之间的员工的工资级别，并按级别进行分组
SELECT * FROM sal_grade;


SELECT COUNT(*) 个数,grade
FROM employees e
JOIN sal_grade g
ON e.`salary` BETWEEN g.`min_salary` AND g.`max_salary`
WHERE e.`department_id` BETWEEN 10 AND 90
GROUP BY g.grade;




#三）自连接

#案例：查询员工名和对应的领导名

SELECT e.`last_name`,m.`last_name`
FROM employees e
JOIN employees m
ON e.`manager_id`=m.`employee_id`;


#二、外连接

/*

说明：查询结果为主表中所有的记录，如果从表有匹配项，则显示匹配项；如果从表没有匹配项，则显示null

应用场景：一般用于查询主表中有但从表没有的记录

特点：

1、外连接分主从表，两表的顺序不能任意调换
2、左连接的话，left join左边为主表
   右连接的话，right join右边为主表
   

语法：

select 查询列表
from 表1 别名
left|right|full 【outer】 join 表2 别名
on 连接条件
where 筛选条件;

*/
USE girls;
#案例1：查询所有女神记录，以及对应的男神名，如果没有对应的男神，则显示为null

#左连接
SELECT b.*,bo.*
FROM beauty b
LEFT JOIN boys bo ON b.`boyfriend_id` = bo.`id`;

#右连接
SELECT b.*,bo.*
FROM boys bo
RIGHT JOIN  beauty b ON b.`boyfriend_id` = bo.`id`;







#案例2：查哪个女神没有男朋友

#左连接
SELECT b.`name`
FROM beauty b
LEFT JOIN boys bo ON b.`boyfriend_id` = bo.`id`
WHERE bo.`id`  IS NULL;

#右连接
SELECT b.*,bo.*
FROM boys bo
RIGHT JOIN  beauty b ON b.`boyfriend_id` = bo.`id`
WHERE bo.`id`  IS NULL;


#案例3：查询哪个部门没有员工，并显示其部门编号和部门名

SELECT COUNT(*) 部门个数
FROM departments d
LEFT JOIN employees e ON d.`department_id` = e.`department_id`
WHERE e.`employee_id` IS NULL;


#一、查询编号>3 的女神的男朋友信息，如果有则列出详细，如果没有，用 null 填充
4   小红     大飞
5   小白     大黄
6   小绿     NULL



SELECT b.id,b.name,bo.*
FROM beauty b
LEFT JOIN boys bo ON b.boyfriend_id = bo.id
WHERE b.id>3;



#二、查询哪个城市没有部门

SELECT l.city
FROM departments d
RIGHT JOIN locations l ON l.location_id = d.location_id
WHERE d.`department_id` IS NULL;


#三、查询部门名为 SAL 或 IT 的员工信息

SELECT d.*,e.*
FROM departments d
LEFT JOIN employees e ON d.`department_id` = e.`department_id`
WHERE d.`department_name` = 'SAL' OR d.`department_name`='IT';


```

**子查询**

```mysql
#子查询
/*
说明：当一个查询语句中又嵌套了另一个完整的select语句，则被嵌套的select语句称为子查询或内查询
外面的select语句称为主查询或外查询。


分类：

按子查询出现的位置进行分类：

1、select后面
	要求：子查询的结果为单行单列（标量子查询）
2、from后面
	要求：子查询的结果可以为多行多列
3、where或having后面 ★
	要求：子查询的结果必须为单列
		单行子查询
		多行子查询
4、exists后面
	要求：子查询结果必须为单列（相关子查询）
	
特点：
	1、子查询放在条件中，要求必须放在条件的右侧
	2、子查询一般放在小括号中
	3、子查询的执行优先于主查询
	4、单行子查询对应了 单行操作符：> < >= <= = <>
	   多行子查询对应了 多行操作符：any/some  all in   






*/

#1. 查询和 Zlotkey 相同部门的员工姓名和工资

SELECT last_name,salary
FROM employees
WHERE department_id = (
	SELECT department_id
	FROM employees
	WHERE last_name = "Zlotkey"
);


SELECT department_id
FROM employees
WHERE last_name = "Zlotkey"


#2. 查询工资比公司平均工资高的员工的员工号，姓名和工资
SELECT AVG(salary)
FROM employees

SELECT employee_id,last_name,salary
FROM employees
WHERE salary > (
	SELECT AVG(salary)
	FROM employees
);

#一、放在where或having后面
#一）单行子查询

#案例1：谁的工资比 Abel 高?


#①查询Abel的工资
SELECT salary
FROM employees
WHERE last_name  = 'Abel'
#②查询salary>①的员工信息
SELECT last_name,salary
FROM employees
WHERE salary>(
	SELECT salary
	FROM employees
	WHERE last_name  <> 'Abel'

);

#案例2：返回job_id与141号员工相同，salary比143号员工多的员工姓名，job_id 和工资
#①查询141号员工的job_id
SELECT job_id
FROM employees
WHERE employee_id = 141

#②查询143号员工的salary

SELECT salary
FROM employees
WHERE employee_id = 143

#③查询job_id=① and salary>②的信息
SELECT last_name,job_id,salary
FROM employees
WHERE job_id = (
	SELECT job_id
	FROM employees
	WHERE employee_id = 141
) AND salary>(

	SELECT salary
	FROM employees
	WHERE employee_id = 143

);



#案例3：返回公司工资最少的员工的last_name,job_id和salary

#①查询最低工资
SELECT MIN(salary)
FROM employees

#②查询salary=①的员工的last_name,job_id和salary
SELECT last_name,job_id,salary
FROM employees
WHERE salary=(
	SELECT MIN(salary)
	FROM employees

);

#案例4：查询最低工资大于50号部门最低工资的部门id和其最低工资

#①查询50号部门的最低工资
SELECT MIN(salary)
FROM employees
WHERE department_id = 50


#②查询各部门的最低工资，筛选看哪个部门的最低工资>①

SELECT MIN(salary),department_id
FROM employees
GROUP BY department_id
HAVING MIN(salary)>(

	SELECT MIN(salary)
	FROM employees
	WHERE department_id = 50
);


#二）多行子查询
/*

in:判断某字段是否在指定列表内  
x in(10,30,50)


any/some:判断某字段的值是否满足其中任意一个

x>any(10,30,50)
x>min()

x=any(10,30,50)
x in(10,30,50)


all:判断某字段的值是否满足里面所有的

x >all(10,30,50)
x >max()

*/


#案例1：返回location_id是1400或1700的部门中的所有员工姓名

#①查询location_id是1400或1700的部门
SELECT department_id
FROM departments
WHERE location_id IN(1400,1700)


#②查询department_id = ①的姓名
SELECT last_name
FROM employees
WHERE department_id IN(
	SELECT DISTINCT department_id
	FROM departments
	WHERE location_id IN(1400,1700)

);



#题目：返回其它部门中比job_id为‘IT_PROG’部门任一工资低的员工的员工号、姓名、job_id 以及salary

#①查询job_id为‘IT_PROG’部门的工资
SELECT DISTINCT salary
FROM employees
WHERE job_id = 'IT_PROG'


#②查询其他部门的工资<任意一个①的结果

SELECT employee_id,last_name,job_id,salary
FROM employees
WHERE salary<ANY(

	SELECT DISTINCT salary
	FROM employees
	WHERE job_id = 'IT_PROG'


);



等价于

SELECT employee_id,last_name,job_id,salary
FROM employees
WHERE salary<(

	SELECT MAX(salary)
	FROM employees
	WHERE job_id = 'IT_PROG'


);




#案例3：返回其它部门中比job_id为‘IT_PROG’部门所有工资都低的员工 的员工号、姓名、job_id 以及salary

#①查询job_id为‘IT_PROG’部门的工资
SELECT DISTINCT salary
FROM employees
WHERE job_id = 'IT_PROG'


#②查询其他部门的工资<所有①的结果

SELECT employee_id,last_name,job_id,salary
FROM employees
WHERE salary<ALL(

	SELECT DISTINCT salary
	FROM employees
	WHERE job_id = 'IT_PROG'


);



等价于

SELECT employee_id,last_name,job_id,salary
FROM employees
WHERE salary<(

	SELECT MIN(salary)
	FROM employees
	WHERE job_id = 'IT_PROG'


);


#二、放在select后面

#案例；查询部门编号是50的员工个数

SELECT 
(
	SELECT COUNT(*)
	FROM employees
	WHERE department_id = 50
)  个数;


#三、放在from后面

#案例：查询每个部门的平均工资的工资级别
#①查询每个部门的平均工资

SELECT AVG(salary),department_id
FROM employees
GROUP BY department_id



#②将①和sal_grade两表连接查询

SELECT dep_ag.department_id,dep_ag.ag,g.grade
FROM sal_grade g
JOIN (

	SELECT AVG(salary) ag,department_id
	FROM employees
	GROUP BY department_id

) dep_ag ON dep_ag.ag BETWEEN g.min_salary AND g.max_salary;


#四、放在exists后面



#案例1 ：查询有无名字叫“张三丰”的员工信息
SELECT EXISTS(
	SELECT * 
	FROM employees
	WHERE last_name = 'Abel'

) 有无Abel;


#案例2：查询没有女朋友的男神信息

USE girls;

SELECT bo.*
FROM boys bo
WHERE bo.`id` NOT IN(
	SELECT boyfriend_id
	FROM beauty b
)



SELECT bo.*
FROM boys bo
WHERE NOT EXISTS(
	SELECT boyfriend_id
	FROM beauty b
	WHERE bo.id = b.boyfriend_id
);


```

**分页查询**

```mysql
#进阶8：分页查询
/*
应用场景：当页面上的数据，一页显示不全，则需要分页显示

分页查询的sql命令请求数据库服务器——>服务器响应查询到的多条数据——>前台页面



语法：

select 查询列表
from 表1 别名
join 表2 别名
on 连接条件
where 筛选条件
group by 分组
having 分组后筛选
order by 排序列表
limit 起始条目索引,显示的条目数

执行顺序：

1》from子句
2》join子句
3》on子句
4》where子句
5》group by子句
6》having子句
7》select子句
8》order by子句
9》limit子句


特点：
①起始条目索引如果不写，默认是0
②limit后面支持两个参数
参数1：显示的起始条目索引
参数2：条目数

公式：

假如要显示的页数是page，每页显示的条目数为size

select *
from employees
limit (page-1)*size,size;

page	size=10
1                       limit 0,10
2			limit 10,10
3			limit 20,10
4			limit 30,10


*/





#案例1：查询员工信息表的前5条
SELECT * FROM employees LIMIT 0,5;
#完全等价于
SELECT * FROM employees LIMIT 5;

#案例2：查询有奖金的，且工资较高的第11名到第20名
SELECT 
    * 
FROM
    employees 
WHERE commission_pct IS NOT NULL 
ORDER BY salary DESC
LIMIT 10,10 ;


#练习：查询年薪最高的前10名

SELECT last_name,salary,salary*12*(1+IFNULL(commission_pct,0)) 年薪
FROM employees
ORDER BY 年薪 DESC
LIMIT 0,10;

```

**联合查询**

```
#进阶9：联合查询
/*
说明：当查询结果来自于多张表，但多张表之间没有关联，这个时候往往使用联合查询，也称为union查询

语法：
select 查询列表 from 表1  where 筛选条件  
	union
select 查询列表 from 表2  where 筛选条件  


特点：

1、多条待联合的查询语句的查询列数必须一致，查询类型、字段意义最好一致
2、union实现去重查询
   union all 实现全部查询，包含重复项
*/

#案例：查询所有国家的年龄>20岁的用户信息

SELECT * FROM usa WHERE uage >20 UNION
SELECT * FROM chinese WHERE age >20 ;


#案例2：查询所有国家的用户姓名和年龄

SELECT uname,uage FROM usa
UNION
SELECT age,`name` FROM chinese;


#案例3：union自动去重/union all 可以支持重复项


SELECT 1,'范冰冰' 
UNION ALL
SELECT 1,'范冰冰' 
UNION  ALL
SELECT 1,'范冰冰' 
UNION  ALL
SELECT 1,'范冰冰' ;

```

**DDL语言**

```mysql
#DDL语言
/*
说明：Data Define Language数据定义语言,用于对数据库和表的管理和操作



*/

#---------------------------库的管理------------------------√

#一、创建数据库
CREATE DATABASE stuDB;
CREATE DATABASE IF NOT EXISTS stuDB;


#二、删除数据库

DROP DATABASE stuDB;

DROP DATABASE IF EXISTS stuDB;





#---------------------------表的管理------------------------


#一、创建表 ★
语法：
CREATE TABLE [IF NOT EXISTS] 表名(
	字段名  字段类型  【字段约束】,
	字段名  字段类型  【字段约束】,
	字段名  字段类型  【字段约束】,
	字段名  字段类型  【字段约束】,
	字段名  字段类型  【字段约束】
	

);


案例：没有添加约束


CREATE TABLE IF NOT EXISTS stuinfo(
	stuid INT ,
	stuname VARCHAR(20),
	stugender CHAR(1),
	email VARCHAR(20),
	borndate DATETIME

);


案例：添加约束
DROP TABLE IF EXISTS stuinfo;
CREATE TABLE IF NOT EXISTS stuinfo(
	stuid INT PRIMARY KEY,#添加了主键约束
	stuname VARCHAR(20) UNIQUE NOT NULL,#添加了唯一约束+非空
	stugender CHAR(1) DEFAULT '男',#添加了默认约束
	email VARCHAR(20) NOT NULL,
	age INT CHECK( age BETWEEN 0 AND 100),#添加了检查约束，mysql不支持
	majorid INT,
	CONSTRAINT fk_stuinfo_major FOREIGN KEY (majorid) REFERENCES major(id)#添加了外键约束

);






#一）数据类型：

1、整型
TINYINT SMALLINT  INT  BIGINT 

2、浮点型
FLOAT(m,n)
DOUBLE(m,n) 
DECIMAL(m,n)
m和n可选



3、字符型

CHAR(n):n可选
VARCHAR(n)：n必选
TEXT
n表示最多字符个数



4、日期型

DATE TIME  DATETIME TIMESTAMP


5、二进制型

BLOB 存储图片数据


#二）常见约束
说明：用于限制表中字段的数据的，从而进一步保证数据表的数据是一致的、准确的、可靠的！

NOT NULL 非空：用于限制该字段为必填项
DEFAULT 默认：用于限制该字段没有显式插入值，则直接显式默认值
PRIMARY KEY 主键：用于限制该字段值不能重复，设置为主键列的字段默认不能为空
	一个表只能有一个主键，当然可以是组合主键
	
UNIQUE 唯一：用于限制该字段值不能重复
		字段是否可以为空		一个表可以有几个
		
	主键	×				1个
	唯一    √				n个
CHECK检查：用于限制该字段值必须满足指定条件
	CHECK(age BETWEEN 1 AND 100)
	
	
FOREIGN KEY 外键:用于限制两个表的关系,要求外键列的值必须来自于主表的关联列
	要求：
	①主表的关联列和从表的关联列的类型必须一致，意思一样，名称无要求
	②主表的关联列要求必须是主键
	
	





#二、修改表[了解]

语法：ALTER TABLE 表名 ADD|MODIFY|CHANGE|DROP COLUMN 字段名 字段类型 【字段约束】;

#1.修改表名

ALTER TABLE stuinfo RENAME TO students;


#2.添加字段
ALTER TABLE students ADD COLUMN borndate TIMESTAMP NOT NULL;

DESC students;#查看表的结构


#3.修改字段名

ALTER TABLE students CHANGE COLUMN borndate birthday DATETIME NULL;




#4.修改字段类型


ALTER TABLE students MODIFY COLUMN birthday TIMESTAMP ;


#5.删除字段

ALTER TABLE students DROP COLUMN birthday;

DESC students;



#三、删除表 √

DROP TABLE IF EXISTS students;


#四、复制表√


#仅仅复制表的结构

CREATE TABLE newTable2 LIKE major;

#复制表的结构+数据

CREATE TABLE newTable3 SELECT * FROM girls.`beauty`;


#案例：复制employees表中的last_name,department_id,salary字段到新表 emp表，但不复制数据

CREATE TABLE emp 
SELECT last_name,department_id,salary 
FROM myemployees.`employees`
WHERE 1=2;
```

**DML语言**

```mysql
#DML★
/*
DML(Data Manipulation Language)数据操纵语言：insert update delete
对表中的数据的增删改
*/

#一、数据 的插入

/*

语法：
插入单行：
	insert into 表名(字段名1,字段名2 ,...) values (值1，值2,...);
插入多行：
	insert into 表名(字段名1,字段名2 ,...) values
	 (值1，值2,...),(值1，值2,...),(值1，值2,...);

特点：

①字段和值列表一一对应
包含类型、约束等必须匹配

②数值型的值，不用单引号
非数值型的值，必须使用单引号

③字段顺序无要求

*/
SELECT * FROM stuinfo;

#案例1：要求字段和值列表一一对应，且遵循类型和约束的限制
INSERT INTO stuinfo(stuid,stuname,stugender,email,age,majorid)
VALUES(1,'吴倩','男','wuqian@qq.com',12,1); 


INSERT INTO stuinfo(stuid,stuname,stugender,email,age,majorid)
VALUES(6,'李宗盛2','女','wuqian@qq.com',45,2); 

#案例2：可以为空字段如何插入

#方案1：字段名和值都不写
INSERT INTO stuinfo(stuid,stuname,email,majorid)
VALUES(5,'齐鱼','qiqin@qq.com',2); 


#方案1：字段名写上，值使用null

INSERT INTO stuinfo(stuid,stuname,email,age,majorid)
VALUES(5,'齐鱼','qiqin@qq.com',NULL,2); 

SELECT * FROM stuinfo;


#案例3：默认字段如何插入

#方案1：字段名写上，值使用default
INSERT INTO stuinfo(stuid,stuname,email,stugender,majorid)
VALUES(7,'齐小鱼','qiqin@qq.com',DEFAULT,2); 

#方案2：字段名和值都不写

INSERT INTO stuinfo(stuid,stuname,email,majorid)
VALUES(7,'齐小鱼','qiqin@qq.com',2); 


#案例4：可以省略字段列表，默认所有字段
INSERT INTO stuinfo VALUES(8,'林忆莲','女','lin@126.com',12,3);


INSERT INTO stuinfo VALUES(NULL,'小黄','男','dd@12.com',12,3);
/*
	自增长必须要设置在主键上，自增长必须为数值型，一个表只能有一个自增长列
*/
#通过代码设置自增长
create table grade(
	gradID INT PRIMARY KEY AUTO_INCREMENT,
    gradName VARCHAR(20)
);

SELECT * FROM stuinfo;

#二、数据 的修改

/*
语法：
update 表名 set 字段名 = 新值,字段名=新值,...
where 筛选条件;


*/


#案例1：修改年龄<20的专业编号为3号，且邮箱更改为 xx@qq.com


UPDATE stuinfo SET majorid = 3,email='xx@qq.com'
WHERE age<20;


#三、数据 的删除
/*

方式1：delete语句

	语法：delete from 表名 where 筛选条件;
方式2：truncate语句
	语法：truncate table 表名;

*/

#案例1：删除姓李所有信息

DELETE FROM stuinfo WHERE stuname LIKE '李%';

#案例2：删除表中所有数据
TRUNCATE TABLE stuinfo ;


#【面试题】delete和truncate的区别

1.delete可以添加WHERE条件
  TRUNCATE不能添加WHERE条件，一次性清除所有数据
2.truncate的效率较高
3.如果删除带自增长列的表，
  使用DELETE删除后，重新插入数据，记录从断点处开始
  使用TRUNCATE删除后，重新插入数据，记录从1开始
  
  SELECT * FROM gradeinfo;

  TRUNCATE TABLE gradeinfo;
  
  INSERT INTO gradeinfo(gradename)VALUES('一年级'),('2年级'),('3年级');
  
4.delete 删除数据，会返回受影响的行数
  TRUNCATE删除数据，不返回受影响的行数
  
5.delete删除数据，可以支持事务回滚
  TRUNCATE删除数据，不支持事务回滚
  
```

## 4. 实物

```mysql
#事务
/*

概念：由一条或多条sql语句组成，要么都成功，要么都失败

特性：ACID

	原子性
	一致性
	隔离性
	持久性


分类：

隐式事务：没有明显的开启和结束标记
	比如dml语句的insert、update、delete语句本身就是一条事务
	
	insert into stuinfo values(1,'john','男','ert@dd.com',12);
	
显式事务：具有明显的开启和结束标记

	一般由多条sql语句组成，必须具有明显的开启和结束标记
	
	
	步骤：
	取消隐式事务自动开启的功能
	
	1、开启事务
	2、编写事务需要的sql语句（1条或多条）
		insert into stuinfo values(1,'john','男','ert@dd.com',12);
		insert into stuinfo values(1,'john','男','ert@dd.com',12);
	3、结束事务
*/





SHOW VARIABLES LIKE '%auto%'

#演示事务的使用步骤

#1、取消事务自动开启
SET autocommit = 0;

#2、开启事务
START TRANSACTION;

#3、编写事务的sql语句

#将张三丰的钱-5000
UPDATE stuinfo SET balance=balance-5000 WHERE stuid = 1;

#将灭绝的钱+5000
UPDATE stuinfo SET balance=balance+5000 WHERE stuid = 2;


#4、结束事务

#提交
#commit;

#回滚
ROLLBACK;



SELECT * FROM stuinfo;
```

