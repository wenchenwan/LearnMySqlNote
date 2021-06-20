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